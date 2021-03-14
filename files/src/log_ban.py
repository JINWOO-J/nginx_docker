#!/usr/bin/env python3.7
from dateutil.parser import parse
import os
import sys
import re
import json
import tailer
import argparse
import copy
from datetime import datetime
from slacker import Slacker
import requests

logs = """
10.254.1.54 54.168.178.97   [13/Mar/2021:21:37:22 +0900] POST /api/v3 HTTP/1.1 200 361  "python-requests/2.22.0" 54.168.178.97 {"jsonrpc": "2.0", "method": "icx_call", "id": 1234, "params": {"from": "hx0000000000000000000000000000000000000000", "to": "cx0000000000000000000000000000000000000000", "dataType": "call", "data": {"method": "getPRep", "params": {"address": "hx9b3e8e0117858294280c0ec677ae18f936cec707"}}}} HTTP/1.1 0.004
58.234.156.144 58.234.156.144   [13/Mar/2021:21:36:55 +0900] POST /api/v3 HTTP/1.1 200 125  "python-requests/2.25.1"  {"jsonrpc": "2.0", "method": "icx_sendTransaction", "id": 0, "params": {"version": "0x3", "nid": "0x3", "from": "hx5a05b58a25a1e5ea0f1d5715e1f655dffc1fb30a", "to": "hx0000000000000000000000000000000000000000", "value": "0x2386f26fc10000", "stepLimit": "0x17d78400", "timestamp": "0x5bd6a4597f739", "nonce": "0x705", "signature": "YRD179sL7eeWqQ9tvT7Zk//aSOFGpTwAF8vxwbIipHpOR6plsgnDYghV55Hp6Y3m78nbuBjFUSn0led/W30klAA="}} HTTP/1.1 0.007
"""
line_format_regex = re.compile(
    r"""(?P<ipaddress>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) (?P<real_ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})   """
    r"""\[(?P<dateandtime>\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2} (\+|\-)\d{4})\] (((GET|POST|OPTIONS|HEAD) )"""
    r"""(?P<url>.+)(http\/1\.1)) (?P<statuscode>\d{3}) (?P<bytessent>\d+) ?(?P<referrer>|(\s).*) (\"(?P<useragent>.*)\") """
    r"""?(.*)?[,]?(\s+)(?P<real_ipaddr>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|)(\s+)(?P<post_data>.+)(HTTP.*)""",
    re.IGNORECASE)


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def is_hex(s):
    try:
        int(s, 16)
    except:
        return False
    return True


def dump(obj, nested_level=0, output=sys.stdout):
    spacing = '   '
    def_spacing = '   '
    if type(obj) == dict:
        print('%s{' % (def_spacing + (nested_level) * spacing))
        for k, v in obj.items():
            if hasattr(v, '__iter__'):
                print(bcolors.OKGREEN + '%s%s:' % (def_spacing + (nested_level + 1) * spacing, k) + bcolors.ENDC, end="")
                dump(v, nested_level + 1, output)
            else:
                # print >>  bcolors.OKGREEN + '%s%s: %s' % ( (nested_level + 1) * spacing, k, v) + bcolors.ENDC
                print(bcolors.OKGREEN + '%s%s:' % (def_spacing + (nested_level + 1) * spacing, k) + bcolors.WARNING + ' %s' % v + bcolors.ENDC,
                      file=output)
        print('%s}' % (def_spacing + nested_level * spacing), file=output)
    elif type(obj) == list:
        print('%s[' % (def_spacing + (nested_level) * spacing), file=output)
        for v in obj:
            if hasattr(v, '__iter__'):
                dump(v, nested_level + 1, output)
            else:
                print(bcolors.WARNING + '%s%s' % (def_spacing + (nested_level + 1) * spacing, v) + bcolors.ENDC, file=output)
        print('%s]' % (def_spacing + (nested_level) * spacing), file=output)
    else:
        print(bcolors.WARNING + '%s%s' % (def_spacing + nested_level * spacing, obj) + bcolors.ENDC)


def classdump(obj):
    for attr in dir(obj):
        if hasattr(obj, attr):
            value = getattr(obj, attr)
            print(bcolors.OKGREEN + f"obj.{attr} = " +
                  bcolors.WARNING + f"{value}" + bcolors.ENDC)


def count_up_dict(dict_data, key, value=None):
    if value:
        if dict_data.get(key, None) is None:
            dict_data[key] = []
        dict_data[key].append(value)
    else:
        if dict_data.get(key, None) is None:
            dict_data[key] = 0

        dict_data[key] += 1

    return dict_data


def time_diff_min(s1, s2):
    FMT = '%Y-%m-%d %H:%M'
    tdelta = datetime.strptime(s2, FMT) - datetime.strptime(s1, FMT)
    try:
        diff = int(str(tdelta).split(":")[1])
    except:
        diff = 0

    return diff


def todaydate(type=None):
    if type is None:
        return '%s' % datetime.now().strftime("%Y%m%d")
    elif type == "ms":
        return '[%s]' % datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    elif type == "ms_text":
        return '%s' % datetime.now().strftime("%Y%m%d-%H%M%S%f")[:-3]


def write_logging(msg):
    send_slack("[IP-BAN]", msg)
    logname = "ip_ban"
    log_path = args.log_path
    log_file_name = f"{log_path}/%s_%s.log" % (logname, todaydate())

    if os.path.isdir(log_path) is False:
        os.mkdir(log_path)

    logfile = open(log_file_name, "a+")
    logfile.write(f"{todaydate('ms')} {msg}  \n")
    logfile.close()


def write_deny_conf(ipaddr_list=[], action="deny"):
    if action is "unban":
        deny_conf_file = open(args.deny, "r")
        lines = deny_conf_file.readlines()
        with open(f"{args.deny}", "w") as f:
            for line in lines:
                for unban_ip in ipaddr_list:
                    if unban_ip not in line:
                        f.write(line)

    elif action is "deny":
        deny_conf_file = open(args.deny, "w")
        for ipaddr in ipaddr_list:
            deny_conf_file.write(f"{action} {ipaddr} ;\n")

    deny_conf_file.close()


def actions(access_count, ban_status, date_min_last, date_min_now):
    for ipaddr, count in access_count.items():
        if count > args.ban_count:
            ban_status = count_up_dict(ban_status, date_min_last, ipaddr)
            write_logging(f"['{date_min_last}'][BAN] {ipaddr}")

    #execute "nginx_throttle"
    #create deny file
    #nginx reload

    ban_ip_list = []
    unban_ip_list = []

    ban_status_tmp = copy.copy(ban_status)
    for ban_time, ipaddr_arr in ban_status.items():
        if time_diff_min(ban_time, date_min_now) >= args.unban_time:
            del ban_status_tmp[ban_time]
            write_logging(f"['{ban_time}'][UNBAN] {ipaddr_arr}")
            unban_ip_list += ipaddr_arr
        else:
            ban_ip_list += ipaddr_arr

    if len(unban_ip_list) > 0:
        write_deny_conf(unban_ip_list, "unban")

    if len(ban_ip_list) > 0:
        write_deny_conf(ban_ip_list)
        ban_count = {}
        for ipaddr in ban_ip_list:
            ban_count[ipaddr] = access_count.get(ipaddr)
        write_logging(f"Write deny.conf, {ban_ip_list}, {ban_count}")

    if len(unban_ip_list) > 0 or len(ban_ip_list) > 0:
        os.system("nginx -s reload")

    return ban_status_tmp


def get_parser():
    parser = argparse.ArgumentParser(description='IP ban for nginx')
    parser.add_argument('-f', '--file', metavar='file', help=f'access log file ', default="/var/log/nginx/access.log")
    parser.add_argument('-d', '--deny', metavar='deny', help=f'deny conf file ', default="/etc/nginx/manual_acl/ip_ban_deny.conf")
    parser.add_argument('-b', '--ban-count', metavar='ban_count', type=int, help=f'ban count', default=100)
    parser.add_argument('-u', '--unban-time', metavar='unban_time', type=int, help=f'unban time', default=5)

    parser.add_argument('-l', '--log-path', metavar='log_path',  help=f'log file', default="/var/log/nginx/logs")
    parser.add_argument('-s', '--slack-token', metavar='token',  help=f'slack token', default="")
    parser.add_argument("-v", "--verbose", action="count", help=f"verbose mode. view level", default=0)

    return parser


def send_slack(title, message):
    token = os.environ.get('SLACK', '')
    channel_name = "#citizen-ban"
    slack = Slacker(token)
    attachments_dict = dict()
    attachments_dict['pretext'] = title
    attachments_dict['title'] = title
    attachments_dict['text'] = f'{todaydate("ms")} [{public_ip}]  {message}'
    attachments_dict['mrkdwn_in'] = ["text", "pretext"]
    attachments = [attachments_dict]
    if token:
        slack.chat.post_message(channel=channel_name, text=None, attachments=attachments, as_user=True)


def get_public_ip():
    return requests.get("http://checkip.amazonaws.com").text.strip()


def test():
    for line in logs.split("\n"):
        print(line)
        data = re.search(line_format_regex, line)
        if data:
            data_dict = data.groupdict()
            try:
                data_dict['post_dict'] = json.loads(data_dict['post_data'])
            except Exception as e:
                data_dict['post_dict'] = {}

            dump(data_dict)


def main():
    global public_ip
    public_ip = get_public_ip()
    file = open(args.file, "r", encoding="utf-8")

    write_logging("Start")

    follow, stop = tailer.follow(file)
    stop_line_cnt = 0
    access_count = {}
    ban_status = {}
    date_min_last = ""
    for line in follow:

        if args.verbose > 3:
            print(line)
        stop_line_cnt += 1
        data = re.search(line_format_regex, line)
        if data:
            data_dict = data.groupdict()
            try:
                data_dict['post_dict'] = json.loads(data_dict['post_data'])
            except Exception as e:
                data_dict['post_dict'] = {}

            if args.verbose > 3:
                print(data_dict)

            datetimestring = parse(data_dict['dateandtime'][:11] + " " + data_dict['dateandtime'][12:])
            date_min_now = str(datetimestring)[:16]

            real_ip = data_dict["real_ip"]

            if args.verbose > 1:
                print(f"-- {real_ip} {data_dict['post_dict'].get('method')}, {data_dict['post_dict']}")

            if data_dict['post_dict'].get("method") == "icx_sendTransaction":
                # dump(data_dict['post_dict'])

                if args.verbose > 1:
                    print(f"- IN {real_ip}")
                access_count = count_up_dict(access_count, real_ip)

            if date_min_last != date_min_now:
                ban_status = actions(access_count, ban_status, date_min_last, date_min_now)

                if args.verbose > 3:
                    dump(access_count)
                    dump(ban_status)

                access_count = {}

            date_min_last = date_min_now
        else:
            print(f"[ERROR] {line}")


if __name__ == '__main__':
    parser = get_parser()
    args = parser.parse_args()
    print(args)
    main()
    # test()
