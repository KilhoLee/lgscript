# SDN reference architecture: scripts for experiments

## File list 
- ``canup.sh`` : CAN 장치 활성화
- ``tapup.sh`` : TAP 장치 활성화
- ``create_vcan.sh`` : VCAN 장치 활성화
- ``dhcp_handler.oldsh``: DHCP 비활성화 (사용하지 않음)
- ``ntp.sh`` : NTP 실행
- ``run_ovs.sh`` : OVS 실행 및 설정
- ``ovs_setup.py`` : OVS 실행 이후 bridge, port, controller, TC qdisc 등 설정
- ``ovs_break.sh`` : OVS 실행 중지
- ``reset_tc.py`` : TC qdisc reset (default qdisc로 변경)
- ``static_arp.sh`` : static ARP 지정

## Note
- 대부분의 파일들은 self-explainable. 파일을 열어보시면 자주 사용하는 명령어들이 적혀있습니다
- ``ovs_setup.py`` : OVS 설정 방법에 대한 대부분의 내용이 기술되어 있음
  - Line 11, ``conmode``: 'inband' 또는 'outband' 지정. 
  - Line 12, ``CONIPADDR``: SDN 컨트롤러가 존재하는 노드의 IP주소
  - Line 15, ``queuemode``: OVS 에서 사용할 TC qdisc 종류 ('htb', 'prio', 'noq')
  - Line 17, ``htbrates``: htb qdisc의 각 sub-queue에서 reserve 할 bandwidth 
  
  - Line 22, ``BR_ADDRPREFIX``: 노드들의 IP주소 prefix (br0의 주소) (예: 10.0.0)
  - Line 23, ``BR_MACPREFIX``: 노드들의 MAC주소 prefix (br0의 주소) (예: 00:00:00:00:00)
  - Line 21, ``MYID``: 현재 노드의 ID. (예: 55)
    - 현재 노드의 IP/MAC 주소는 PREFIX+ID 로 지정됨. (예: 10.0.0.55, 00:00:00:00:00:55)
    - *Note:*  MAC은 hex value라 마지막 byte가 decimal 55값을 갖지는 않음. 하지만, 주소는 단순히 각 노드를 구분하기 위한 용도이므로 상관없음.
- *Note:* qdisc 설정에 guide가 필요한 경우, Line 64 \- 98 참고
