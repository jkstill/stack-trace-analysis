
# Stack Trace Tools

When an Oracle ORA-00600 or ORA-07445 error is encountered, a message is written to the database alert log.

In addition there are trace files generated in the trace directory as well as the incident directory.

There is a section of the trace file called the 'Call Stack Trace' which is a chain of the functions that were called leading up to the Oracle Error.

This stack trace is quite useful for searching My Oracle Support, as a search based on the stack trace often leads to a known bug.

The first argument for ORA-00600 or ORA-07445 error is also useful for searching; those are displayed as well if available.

The problem with the stack trace is that it is not very user friendly.

Following is a portion of a typical Call Stack Trace

```bash

----- Call Stack Trace -----
calling              call     entry                argument values in hex
location             type     point                (? means dubious value)
-------------------- -------- -------------------- ----------------------------

*** 2018-10-17 14:09:56.694
skdstdst()+45        call     kgdsdst()            7F8C6CFF2678 000000003
                                                   7F8C6CFD40B0 ? 7F8C6CFD41C8 ?
                                                   7F8C6CFF1EA8 ? 000000083 ?
ksedst()+119         call     skdstdst()           7F8C6CFF2678 000000001
                                                   000000001 7F8C6CFD41C8 ?
                                                   7F8C6CFF1EA8 ? 000000083 ?
dbkedDefDump()+1119  call     ksedst()             000000001 000000001 ?
                                                   000000001 ? 7F8C6CFD41C8 ?
                                                   7F8C6CFF1EA8 ? 000000083 ?
ksedmp()+261         call     dbkedDefDump()       000000003 000000003
                                                   000000001 ? 7F8C6CFD41C8 ?
                                                   7F8C6CFF1EA8 ? 000000083 ?
ssexhd()+2650        call     ksedmp()             00000044F 000000003 ?
                                                   000000001 ? 000000003
                                                   7F8C6CFF1EA8 ? 000000083 ?
sslsshandler()+456   call     ssexhd()             202F206C69617641
                                                   3D20296C61746F54
                                                   352E333631343720
                                                   353135202F204D30
                                                   A4D38312E343234 000000083 ?
__sighandler()       call     sslsshandler()       000002000 000000000 000000000
                                                   353135202F204D30 ?
                                                   A4D38312E343234 ? 000000083 ?
kghalf()+97          signal   __sighandler()       000000000 000000078 000000060
                                                   000000000 ? 000000000 ?
                                                   00D6B4300 ?
kfdIterInit()+107    call     kghalf()             7F8C7154CCA0 000000000 ?

...
                                                   000000000 ? 00D6B4300 ?
dbgexPhaseII()+1845  call     ksfdmp()             7F8C7154CCA0 0000003EB
                                                   000000004 ? 000000002 ?
                                                   000000000 ? 00D6B4300 ?
dbgexExplicitEndInc  call     dbgexPhaseII()       7F8C7150C648 7F8C6D02C358
()+631                                             7FFD484D2538 000000002 ?
                                                   000000000 ? 00D6B4300 ?
dbgeEndDDEInvocatio  call     dbgexExplicitEndInc  7F8C7150C648 7F8C6D02C358
nImpl()+650                   ()                   7FFD484D2538 ? 000000002 ?
                                                   000000000 ? 00D6B4300 ?
dbgeEndDDEInvocatio  call     dbgeEndDDEInvocatio  7F8C7150C648 7F8C6D02C358
n()+56                        nImpl()              7FFD484D2538 ? 000000002 ?
                                                   000000000 ? 00D6B4300 ?
kghnerror()+466      call     dbgeEndDDEInvocatio  7F8C7150C648 7F8C6D02C358 ?
                              n()                  7FFD484D2538 ? 000000002 ?
                                                   000000000 ? 00D6B4300 ?
kghfrempty_sh_all_d  call     kghnerror()          7F8C7154CCA0 ? 7F8C6C296070 ?
epth()+557                                         00EB66D48 ? 12FABA50D8 ?
                                                   7FFD00000000 00D6B4300 ?
kghfrempty_subheaps  call     kghfrempty_sh_all_d  7F8C7154CCA0 ? 7F8C6C296070 ?
_all()+257                    epth()               00EB66D48 ? 12FABA50D8 ?
                                                   7FFD00000000 ? 00D6B4300 ?
kghfrempty_ex()+118  call     kghfrempty_subheaps  7F8C7154CCA0 ? 7F8C7154CCA0 ?
                              _all()               00EB66D48 ? 12FABA50D8 ?
                                                   7FFD00000000 ? 00D6B4300 ?
qesmmIPgaFreeCb()+4  call     kghfrempty_ex()      000000000 ? 000000004 ?
34                                                 00EB66D48 ? 12FABA50D8 ?
                                                   7FFD00000000 ? 00D6B4300 ?
ksu_dispatch_tac()+  call     qesmmIPgaFreeCb()    000000000 ? 12FABA50D8 ?
1060                                               00EB66D48 ? 12FABA50D8 ?
                                                   7FFD00000000 ? 00D6B4300 ?
kcra_scan_redo()+10  call     ksu_dispatch_tac()   000000000 ? 12FABA50D8 ?
491                                                05BC77AF3 12FABA50D8 ?
                                                   7FFD00000000 ? 00D6B4300 ?
kcra_dump_redo()+24  call     kcra_scan_redo()     7FFD484D5970 000000001
02                                                 7FFD484D5284 000000000

...

opiodr()+1165        call     opiino()             00000003C 000000004
                                                   7FFD484DC318 000000000 ?
                                                   7FFD484DA6C8 ? 7FFD484DAE7C ?
opidrv()+587         call     opiodr()             00000003C 000000004
                                                   7FFD484DC318 ? 000000000 ?
                                                   7FFD484DA6C8 ? 000000000
sou2o()+145          call     opidrv()             00000003C 000000004
                                                   7FFD484DC318 000000000 ?
                                                   7FFD484DA6C8 ? 000000000 ?
opimai_real()+154    call     sou2o()              7FFD484DC2F0 00000003C
                                                   000000004 7FFD484DC318
                                                   7FFD484DA6C8 ? 000000000 ?
ssthrdmain()+412     call     opimai_real()        000000000 7FFD484DC600
                                                   000000004 ? 7FFD484DC318 ?
                                                   7FFD484DA6C8 ? 000000000 ?
main()+236           call     ssthrdmain()         000000000 000000002
                                                   7FFD484DC600 000000001
                                                   000000000 000000000 ?
__libc_start_main()  call     main()               7FFD484DE747 7FFD484DE755
+253                                               7FFD484DC600 ? 000000001 ?
                                                   000000000 ? 000000000 ?
_start()+41          call     __libc_start_main()  000BC27B0 000000002
                                                   7FFD484DC7F8 000000000 ?
                                                   000000000 ? 000000000 ?


```

The bits we want to search MOS on are those in the first column.

The stack is shown from the bottom up, that is, the 'start' is at the bottom of the stack, with the most recent function called being at the top of the stack.

As this is an stack trace generated by an error, many of the functions at the top are of little interest.

Functions that includ 'dmp', 'dump' or similar terms invoked as part of the error process.

Similarly, those at the bottom of the stack may be of little interest as well.

Getting the list of functions to search on is always a challenge, as it requires a lot of manual copying and pasting.

The parts of interest are the names of the functions. For this purpose we do not care about the offsets.

So rather than some_function()+1234, we just want some_function().

The following two scripts were created to get the call stacks, SQL, SQL_ID and the first argument to the ORA-600 or ORA-7445 error.

# get-stack.pl 

Given a trace file with an ORA-00600 error, get-stack.pl will extract the SQL_ID, SQL text, Call Stack and the first argument to the errors

Following is an example:

```bash
 ./get-stack.pl < trace/floltp2_ora_16471_i1480050.trc


SQL_ID 3w84s3zf9dt8q

SELECT
       T3.CONFLICT_ID,
       T3.LAST_UPD,
       T3.CREATED,
       T3.LAST_UPD_BY,
       T3.CREATED_BY,
       T3.MODIFICATION_NUM,
       T3.ROW_ID,
       T3.X_PAY_ACCNT_NUM_NEW,
       T3.ACCNT_BANK_NAME,
       T3.ACCNT_BANK_BRANCH,
       T3.BL_ADDR_LINE_2,
       T3.PROFILE_NAME,
       T3.PROFILE_STATUS_CD,
       T3.BL_ADDR_ORG_ID,
       T3.DRIVER_LICENSE_NUM,
       T3.EXPIRATION_DT,
       T3.EXPIRATION_MO_CD,
       T3.VERIFICATION_NUM,
       T3.BL_STATE,
       T3.BANK_ACCT_ID,
       T3.PAY_TYPE_CD,
       T3.X_CC_NUM_NEW,
       T3.BANK_ADDR_ID,
       T3.BL_ADDR,
       T3.BL_ADDR_ID,
       T3.BL_CITY,
       T3.X_PAY_TYPE_INTID,
       T3.X_CC_MASKING,
       T2.SALES_EMP_CNT,
       T2.OU_TYPE_CD,
       T3.X_ETC_ACCOUNT_ID,
       T3.X_ACH_NUM_LAST4,
       T3.X_CC_NUM_LAST4,
       T3.BL_COUNTRY,
       T3.PARTY_ID,
       T3.PAY_METH_CD,
       T3.ABA_ROUTING_NUM,
       T3.EXPIRATION_YR_CD,
       T3.CCVNUM_ENCRPKY_REF,
       T3.DATE_OF_BIRTH,
       T3.DESC_TEXT,
       T3.BL_ZIPCODE,
       T3.HOLDER_NAME,
       T3.X_ACCNTNUM_MASKING,
       T2.CUST_STAT_CD,
       T3.ACCNT_BANK_NAME,
       T3.BL_PROVINCE,
       T3.X_SEQUENCE_NO,
       T3.DESC_TEXT,
       T3.X_BL_FST_NAME,
       T3.X_BL_LST_NAME,
       T3.X_BL_ADDR_ID,
       T3.CCVNUM_ENCRPKY_REF,
       T1.ADDR_LINE_2,
       T1.CITY,
       T1.COUNTRY,
       T1.STATE,
       T1.ZIPCODE,
       T1.ADDR,
       T1.ROW_ID
    FROM
        SIEBEL.S_ADDR_PER T1,
        SIEBEL.S_ORG_EXT T2,
        SIEBEL.S_PTY_PAY_PRFL T3
    WHERE
       T3.PARTY_ID = T2.ROW_ID (+) AND
       T3.BANK_ADDR_ID = T1.ROW_ID (+) AND
       (T3.ROW_ID = :1)


skdstdst() ksedst() dbkedDefDump() ksedmp() ssexhd() sslsshandler() __sighandler() kghalf() kfdIterInit() kfgrpDump() kfgpnDump() kfgscDump() kssdmp1() kssdmh() kfgsoDump() kssdmp1() kssdmh() ksudmp_proc() ksudmp() kssdmp() ksudps() dbkedDefDump() ksedmp() ksfdmp() dbgexPhaseII() dbgexExplicitEndInc() dbgeEndDDEInvocationImpl() dbgeEndDDEInvocation() kghnerror() kghfrempty_sh_all_depth() kghfrempty_subheaps_all() kghfrempty_ex() qesmmIPgaFreeCb() ksu_dispatch_tac() kcra_scan_redo() kcra_dump_redo() kcra_dump_redo_internal() kcra_dump_redo_rdbas_helper() kcra_dump_redo_ltsn_lrdba() kcbdnbRedo() kcbdnb() dbkedDefDump() ksedmp() ksupop() opiodr() ttcpip() opitsk() opiino() opiodr() opidrv() sou2o() opimai_real() ssthrdmain() main() __libc_start_main() _start()+41

Arguments:

Error: ORA-00600
                        kghfrh1     1
     kghfrempty_sh_all_depth:ds     3

Error: ORA-07445
                    kghalf()+97     1


```


# get-stack.sh

The get-stack.sh script is designed to search an alert.log file for ORA-00600 and ORA-07445 errors, locate the incident files, and then scan each file with get-stack.pl.

A text report file will be created from the output.

```bash

$ ./get-stack.sh -h

usage: get-stack.sh

  get-stack.sr -a alert.log -r report.txt

   -a path to alert log
   -f output report - defaults to stack-rpt.txt

```

Here is an example run:

Note: output appears on stdout as well, not shown here

```bash

$ ./get-stack.sh -a /u01/app/oracle/diag/rdbms/floltp/floltp2/trace/alert_floltp2.log -f stack-trace-rpt.txt
Error! - Cowardly refusing to overwrite stack-trace-rpt.txt

$ rm stack-trace-rpt.txt
$ ./get-stack.sh -a /u01/app/oracle/diag/rdbms/floltp/floltp2/trace/alert_floltp2.log -f stack-trace-rpt.txt


$ head -57 stack-trace-rpt.txt
################### floltp2_ora_111654_i1196873.trc ###################

SQL_ID ddywr9v2tc7xk

 INSERT INTO SIEBEL.S_INVOICE  (
       CONFLICT_ID,
       DB_LAST_UPD_SRC,
       DB_LAST_UPD,
       LAST_UPD,
       CREATED,
       LAST_UPD_BY,
       CREATED_BY,
       MODIFICATION_NUM,
       ROW_ID,
       X_QTY,
       COMMENTS,
       BL_ADDR_ID,
       INVC_DT,
       REVISION_NUM,
       TTL_INVC_AMT,
       SURCHARGE_AMT,
       X_UNIT_PRICE,
       X_TOD_ID,
       INVC_TYPE_CD,
       ACCNT_ID,
       DELINQUENT_FLG,
       X_SUB_CATEGORY,
       X_CATEGORY,
       INVC_FULLY_PAID_DT,
       AMT_CURCY_CD,
       PAYMENT_TERM_ID,
       BL_PERIOD_ID,
       ACCNT_INVC_NUM,
       BALANCE_FWD,
       INTEGRATION_ID,
       GROSS_AMT,
       CUST_SIGN_OFF_FLG,
       STATUS_CD,
       REMIT_ORG_INT_ID,
       INVC_NUM,
       GOODS_DLVRD_FLG,
       X_REF_CD,
       FILE_DATE)
 VALUES (:1, :2, sysdate, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, :23, :24, :25, :26, :27, :28, :29, :30, :31, :32, :33, :34, :35, :36, :37)
 [TOC00005-END]

 [TOC00006]


skdstdst() ksedst() dbkedDefDump() ksedmp() ksfdmp() dbgexPhaseII() dbgexExplicitEndInc() dbgeEndDDEInvocationImpl() dbgeEndDDEInvocation() kcbzib() kcbget() ktbxchg() kdifind() kdiins1() kdiinsp0() kauxsin() qesltcLoadIndexList() qesltcLoadIndexes() qerltcNoKdtBufferedInsRowCBK() qerltcSingleRowLoad() qerltcFetch() insexe() opiexe() kpoal8() opiodr() ttcpip() opitsk() opiino() opiodr() opidrv() sou2o() opimai_real() ssthrdmain() main() __libc_start_main() _start()+41 [TOC00006-END][TOC00007]


Arguments:

Error: ORA-00600
                       kcbzib_6     1

```



