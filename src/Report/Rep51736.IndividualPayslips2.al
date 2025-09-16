#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51736 "Individual Payslips 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Individual Payslips 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            DataItemTableView = sorting("Employee Code","Payroll Period") order(ascending) where("Basic Pay"=filter(<>0),Status=filter(Normal));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Employee Code",Status;
            column(ReportForNavId_6207; 6207)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102755015;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756027;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756028;COMPANYNAME)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Picture_Control1102756014;CompanyInfo.Picture)
            {
            }
            column(HR_Employee_No_;emp1."No.")
            {
            }
            column(Trans_1__1_;Trans[1][1])
            {
            }
            column(TransAmt_1__1_;TransAmt[1][1])
            {
            }
            column(TransBal_1__1_;TransBal[1][1])
            {
            }
            column(TransBal_1__2_;TransBal[1][2])
            {
            }
            column(TransAmt_1__2_;TransAmt[1][2])
            {
            }
            column(Trans_1__2_;Trans[1][2])
            {
            }
            column(TransBal_1__3_;TransBal[1][3])
            {
            }
            column(TransAmt_1__3_;TransAmt[1][3])
            {
            }
            column(Trans_1__3_;Trans[1][3])
            {
            }
            column(TransBal_1__4_;TransBal[1][4])
            {
            }
            column(TransBal_1__5_;TransBal[1][5])
            {
            }
            column(TransBal_1__6_;TransBal[1][6])
            {
            }
            column(TransAmt_1__4_;TransAmt[1][4])
            {
            }
            column(TransAmt_1__5_;TransAmt[1][5])
            {
            }
            column(TransAmt_1__6_;TransAmt[1][6])
            {
            }
            column(Trans_1__4_;Trans[1][4])
            {
            }
            column(Trans_1__5_;Trans[1][5])
            {
            }
            column(Trans_1__6_;Trans[1][6])
            {
            }
            column(TransBal_1__7_;TransBal[1][7])
            {
            }
            column(TransBal_1__8_;TransBal[1][8])
            {
            }
            column(TransBal_1__9_;TransBal[1][9])
            {
            }
            column(TransAmt_1__7_;TransAmt[1][7])
            {
            }
            column(TransAmt_1__8_;TransAmt[1][8])
            {
            }
            column(TransAmt_1__9_;TransAmt[1][9])
            {
            }
            column(Trans_1__7_;Trans[1][7])
            {
            }
            column(Trans_1__8_;Trans[1][8])
            {
            }
            column(Trans_1__9_;Trans[1][9])
            {
            }
            column(TransBal_1__10_;TransBal[1][10])
            {
            }
            column(TransBal_1__12_;TransBal[1][12])
            {
            }
            column(TransBal_1__13_;TransBal[1][13])
            {
            }
            column(TransAmt_1__10_;TransAmt[1][10])
            {
            }
            column(TransAmt_1__12_;TransAmt[1][12])
            {
            }
            column(TransAmt_1__13_;TransAmt[1][13])
            {
            }
            column(Trans_1__10_;Trans[1][10])
            {
            }
            column(Trans_1__12_;Trans[1][12])
            {
            }
            column(Trans_1__13_;Trans[1][13])
            {
            }
            column(TransBal_1__14_;TransBal[1][14])
            {
            }
            column(TransBal_1__15_;TransBal[1][15])
            {
            }
            column(TransBal_1__16_;TransBal[1][16])
            {
            }
            column(TransBal_1__17_;TransBal[1][17])
            {
            }
            column(TransBal_1__18_;TransBal[1][18])
            {
            }
            column(TransBal_1__19_;TransBal[1][19])
            {
            }
            column(TransBal_1__11_;TransBal[1][11])
            {
            }
            column(TransBal_1__20_;TransBal[1][20])
            {
            }
            column(TransAmt_1__14_;TransAmt[1][14])
            {
            }
            column(TransAmt_1__15_;TransAmt[1][15])
            {
            }
            column(TransAmt_1__16_;TransAmt[1][16])
            {
            }
            column(TransAmt_1__17_;TransAmt[1][17])
            {
            }
            column(TransAmt_1__18_;TransAmt[1][18])
            {
            }
            column(TransAmt_1__19_;TransAmt[1][19])
            {
            }
            column(TransAmt_1__11_;TransAmt[1][11])
            {
            }
            column(TransAmt_1__20_;TransAmt[1][20])
            {
            }
            column(Trans_1__14_;Trans[1][14])
            {
            }
            column(Trans_1__15_;Trans[1][15])
            {
            }
            column(Trans_1__16_;Trans[1][16])
            {
            }
            column(Trans_1__17_;Trans[1][17])
            {
            }
            column(Trans_1__18_;Trans[1][18])
            {
            }
            column(Trans_1__19_;Trans[1][19])
            {
            }
            column(Trans_1__11_;Trans[1][11])
            {
            }
            column(Trans_1__20_;Trans[1][20])
            {
            }
            column(Addr_1__1_;'PF NO.:       '+Format(Addr[1][1]))
            {
            }
            column(Addr_1__2_;'DEPARTMENT:  '+Addr[1][2])
            {
            }
            column(Addr_1__3_;'PERIOD:  '+Addr[1][3])
            {
            }
            column(Addr_1__4_;Addr[1][4])
            {
            }
            column(Addr_1__5_;Addr[1][5])
            {
            }
            column(Addr_1__6_;Addr[1][6])
            {
            }
            column(Addr_1__7_;Addr[1][7])
            {
            }
            column(Addr_1__8_;Addr[1][8])
            {
            }
            column(Addr_1__9_;Addr[1][9])
            {
            }
            column(Addr_1__10_;Addr[1][10])
            {
            }
            column(TransBal_1__21_;TransBal[1][21])
            {
            }
            column(TransBal_1__22_;TransBal[1][22])
            {
            }
            column(TransAmt_1__21_;TransAmt[1][21])
            {
            }
            column(TransAmt_1__22_;TransAmt[1][22])
            {
            }
            column(TransBal_1__23_;TransBal[1][23])
            {
            }
            column(TransAmt_1__23_;TransAmt[1][23])
            {
            }
            column(TransBal_1__24_;TransBal[1][24])
            {
            }
            column(TransAmt_1__24_;TransAmt[1][24])
            {
            }
            column(Trans_1__21_;Trans[1][21])
            {
            }
            column(Trans_1__23_;Trans[1][23])
            {
            }
            column(Trans_1__24_;Trans[1][24])
            {
            }
            column(Trans_1__22_;Trans[1][22])
            {
            }
            column(TransBal_1__25_;TransBal[1][25])
            {
            }
            column(TransAmt_1__25_;TransAmt[1][25])
            {
            }
            column(Trans_1__25_;Trans[1][25])
            {
            }
            column(TransBal_1__26_;TransBal[1][26])
            {
            }
            column(TransAmt_1__26_;TransAmt[1][26])
            {
            }
            column(Trans_1__26_;Trans[1][26])
            {
            }
            column(TransBal_1__27_;TransBal[1][27])
            {
            }
            column(TransAmt_1__27_;TransAmt[1][27])
            {
            }
            column(Trans_1__27_;Trans[1][27])
            {
            }
            column(TransBal_1__28_;TransBal[1][28])
            {
            }
            column(TransAmt_1__28_;TransAmt[1][28])
            {
            }
            column(Trans_1__28_;Trans[1][28])
            {
            }
            column(TransBal_1__29_;TransBal[1][29])
            {
            }
            column(TransAmt_1__29_;TransAmt[1][29])
            {
            }
            column(Trans_1__29_;Trans[1][29])
            {
            }
            column(TransBal_1__30_;TransBal[1][30])
            {
            }
            column(TransAmt_1__30_;TransAmt[1][30])
            {
            }
            column(Trans_1__30_;Trans[1][30])
            {
            }
            column(TransBal_1__31_;TransBal[1][31])
            {
            }
            column(TransAmt_1__31_;TransAmt[1][31])
            {
            }
            column(Trans_1__31_;Trans[1][31])
            {
            }
            column(TransBal_1__32_;TransBal[1][32])
            {
            }
            column(TransBal_1__33_;TransBal[1][33])
            {
            }
            column(TransBal_1__34_;TransBal[1][34])
            {
            }
            column(TransBal_1__35_;TransBal[1][35])
            {
            }
            column(TransBal_1__36_;TransBal[1][36])
            {
            }
            column(TransBal_1__37_;TransBal[1][37])
            {
            }
            column(TransBal_1__38_;TransBal[1][38])
            {
            }
            column(TransBal_1__39_;TransBal[1][39])
            {
            }
            column(TransBal_1__40_;TransBal[1][40])
            {
            }
            column(TransAmt_1__32_;TransAmt[1][32])
            {
            }
            column(TransAmt_1__33_;TransAmt[1][33])
            {
            }
            column(TransAmt_1__34_;TransAmt[1][34])
            {
            }
            column(TransAmt_1__35_;TransAmt[1][35])
            {
            }
            column(TransAmt_1__36_;TransAmt[1][36])
            {
            }
            column(TransAmt_1__37_;TransAmt[1][37])
            {
            }
            column(TransAmt_1__38_;TransAmt[1][38])
            {
            }
            column(TransAmt_1__39_;TransAmt[1][39])
            {
            }
            column(TransAmt_1__40_;TransAmt[1][40])
            {
            }
            column(Trans_1__32_;Trans[1][32])
            {
            }
            column(Trans_1__34_;Trans[1][34])
            {
            }
            column(Trans_1__35_;Trans[1][35])
            {
            }
            column(Trans_1__33_;Trans[1][33])
            {
            }
            column(Trans_1__36_;Trans[1][36])
            {
            }
            column(Trans_1__37_;Trans[1][37])
            {
            }
            column(Trans_1__38_;Trans[1][38])
            {
            }
            column(Trans_1__39_;Trans[1][39])
            {
            }
            column(Trans_1__40_;Trans[1][40])
            {
            }
            column(Trans_1__45_;Trans[1][45])
            {
            }
            column(TransAmt_1__45_;TransAmt[1][45])
            {
            }
            column(TransAmt_1__46_;TransAmt[1][46])
            {
            }
            column(TransAmt_1__47_;TransAmt[1][47])
            {
            }
            column(TransAmt_1__48_;TransAmt[1][48])
            {
            }
            column(TransAmt_1__49_;TransAmt[1][49])
            {
            }
            column(Trans_1__46_;Trans[1][46])
            {
            }
            column(Trans_1__47_;Trans[1][47])
            {
            }
            column(Trans_1__48_;Trans[1][48])
            {
            }
            column(Trans_1__49_;Trans[1][49])
            {
            }
            column(TransAmt_1__50_;TransAmt[1][50])
            {
            }
            column(TransAmt_1__51_;TransAmt[1][51])
            {
            }
            column(Trans_1__50_;Trans[1][50])
            {
            }
            column(Trans_1__51_;Trans[1][51])
            {
            }
            column(Trans_1__53_;Trans[1][53])
            {
            }
            column(TransBal_1__42_;TransBal[1][42])
            {
            }
            column(TransAmt_1__42_;TransAmt[1][42])
            {
            }
            column(Trans_1__42_;Trans[1][42])
            {
            }
            column(TransBal_1__43_;TransBal[1][43])
            {
            }
            column(TransAmt_1__43_;TransAmt[1][43])
            {
            }
            column(Trans_1__43_;Trans[1][43])
            {
            }
            column(TransBal_1__44_;TransBal[1][44])
            {
            }
            column(TransAmt_1__44_;TransAmt[1][44])
            {
            }
            column(Trans_1__44_;Trans[1][44])
            {
            }
            column(Trans_1__41_;Trans[1][41])
            {
            }
            column(TransAmt_1__41_;TransAmt[1][41])
            {
            }
            column(TransBal_1__41_;TransBal[1][41])
            {
            }
            column(Addr_2__1_;'PF NO.:       '+Format(Addr[2][1]))
            {
            }
            column(Addr_2__2_;'DEPARTMENT:  '+Addr[2][2])
            {
            }
            column(Addr_2__3_;'PERIOD:  '+Addr[2][3])
            {
            }
            column(Addr_2__4_;Addr[2][4])
            {
            }
            column(Addr_2__5_;Addr[2][5])
            {
            }
            column(Addr_2__6_;Addr[2][6])
            {
            }
            column(Addr_2__7_;Addr[2][7])
            {
            }
            column(Addr_2__8_;Addr[2][8])
            {
            }
            column(Addr_2__9_;Addr[2][9])
            {
            }
            column(Addr_2__10_;Addr[2][10])
            {
            }
            column(TransAmt_2__1_;TransAmt[2][1])
            {
            }
            column(Trans_2__1_;Trans[2][1])
            {
            }
            column(TransBal_2__1_;TransBal[2][1])
            {
            }
            column(TransBal_2__2_;TransBal[2][2])
            {
            }
            column(TransAmt_2__2_;TransAmt[2][2])
            {
            }
            column(Trans_2__2_;Trans[2][2])
            {
            }
            column(TransBal_2__3_;TransBal[2][3])
            {
            }
            column(TransAmt_2__3_;TransAmt[2][3])
            {
            }
            column(Trans_2__3_;Trans[2][3])
            {
            }
            column(TransBal_2__4_;TransBal[2][4])
            {
            }
            column(TransAmt_2__4_;TransAmt[2][4])
            {
            }
            column(Trans_2__4_;Trans[2][4])
            {
            }
            column(TransBal_2__5_;TransBal[2][5])
            {
            }
            column(TransAmt_2__5_;TransAmt[2][5])
            {
            }
            column(Trans_2__5_;Trans[2][5])
            {
            }
            column(TransBal_2__6_;TransBal[2][6])
            {
            }
            column(TransAmt_2__6_;TransAmt[2][6])
            {
            }
            column(Trans_2__6_;Trans[2][6])
            {
            }
            column(TransBal_2__7_;TransBal[2][7])
            {
            }
            column(TransAmt_2__7_;TransAmt[2][7])
            {
            }
            column(Trans_2__7_;Trans[2][7])
            {
            }
            column(TransBal_2__8_;TransBal[2][8])
            {
            }
            column(TransAmt_2__8_;TransAmt[2][8])
            {
            }
            column(Trans_2__8_;Trans[2][8])
            {
            }
            column(TransBal_2__9_;TransBal[2][9])
            {
            }
            column(TransAmt_2__9_;TransAmt[2][9])
            {
            }
            column(Trans_2__9_;Trans[2][9])
            {
            }
            column(TransBal_2__10_;TransBal[2][10])
            {
            }
            column(TransAmt_2__10_;TransAmt[2][10])
            {
            }
            column(Trans_2__10_;Trans[2][10])
            {
            }
            column(TransBal_2__11_;TransBal[2][11])
            {
            }
            column(TransAmt_2__11_;TransAmt[2][11])
            {
            }
            column(Trans_2__11_;Trans[2][11])
            {
            }
            column(TransBal_2__12_;TransBal[2][12])
            {
            }
            column(TransAmt_2__12_;TransAmt[2][12])
            {
            }
            column(Trans_2__12_;Trans[2][12])
            {
            }
            column(TransBal_2__13_;TransBal[2][13])
            {
            }
            column(TransAmt_2__13_;TransAmt[2][13])
            {
            }
            column(Trans_2__13_;Trans[2][13])
            {
            }
            column(TransBal_2__14_;TransBal[2][14])
            {
            }
            column(TransAmt_2__14_;TransAmt[2][14])
            {
            }
            column(Trans_2__14_;Trans[2][14])
            {
            }
            column(TransBal_2__15_;TransBal[2][15])
            {
            }
            column(TransAmt_2__15_;TransAmt[2][15])
            {
            }
            column(Trans_2__15_;Trans[2][15])
            {
            }
            column(TransBal_2__16_;TransBal[2][16])
            {
            }
            column(TransAmt_2__16_;TransAmt[2][16])
            {
            }
            column(Trans_2__16_;Trans[2][16])
            {
            }
            column(TransBal_2__17_;TransBal[2][17])
            {
            }
            column(TransAmt_2__17_;TransAmt[2][17])
            {
            }
            column(Trans_2__17_;Trans[2][17])
            {
            }
            column(TransBal_2__18_;TransBal[2][18])
            {
            }
            column(TransAmt_2__18_;TransAmt[2][18])
            {
            }
            column(Trans_2__18_;Trans[2][18])
            {
            }
            column(TransBal_2__19_;TransBal[2][19])
            {
            }
            column(TransAmt_2__19_;TransAmt[2][19])
            {
            }
            column(Trans_2__19_;Trans[2][19])
            {
            }
            column(TransBal_2__20_;TransBal[2][20])
            {
            }
            column(TransAmt_2__20_;TransAmt[2][20])
            {
            }
            column(Trans_2__20_;Trans[2][20])
            {
            }
            column(Trans_2__21_;Trans[2][21])
            {
            }
            column(TransAmt_2__21_;TransAmt[2][21])
            {
            }
            column(TransBal_2__21_;TransBal[2][21])
            {
            }
            column(Trans_2__22_;Trans[2][22])
            {
            }
            column(TransAmt_2__22_;TransAmt[2][22])
            {
            }
            column(TransBal_2__22_;TransBal[2][22])
            {
            }
            column(Trans_2__23_;Trans[2][23])
            {
            }
            column(TransAmt_2__23_;TransAmt[2][23])
            {
            }
            column(TransBal_2__23_;TransBal[2][23])
            {
            }
            column(Trans_2__24_;Trans[2][24])
            {
            }
            column(TransAmt_2__24_;TransAmt[2][24])
            {
            }
            column(TransBal_2__24_;TransBal[2][24])
            {
            }
            column(Trans_2__25_;Trans[2][25])
            {
            }
            column(TransAmt_2__25_;TransAmt[2][25])
            {
            }
            column(TransBal_2__25_;TransBal[2][25])
            {
            }
            column(Trans_2__26_;Trans[2][26])
            {
            }
            column(TransAmt_2__26_;TransAmt[2][26])
            {
            }
            column(TransBal_2__26_;TransBal[2][26])
            {
            }
            column(Trans_2__27_;Trans[2][27])
            {
            }
            column(TransAmt_2__27_;TransAmt[2][27])
            {
            }
            column(TransBal_2__27_;TransBal[2][27])
            {
            }
            column(Trans_2__28_;Trans[2][28])
            {
            }
            column(TransAmt_2__28_;TransAmt[2][28])
            {
            }
            column(TransBal_2__28_;TransBal[2][28])
            {
            }
            column(Trans_2__29_;Trans[2][29])
            {
            }
            column(TransAmt_2__29_;TransAmt[2][29])
            {
            }
            column(TransBal_2__29_;TransBal[2][29])
            {
            }
            column(Trans_2__30_;Trans[2][30])
            {
            }
            column(TransAmt_2__30_;TransAmt[2][30])
            {
            }
            column(TransBal_2__30_;TransBal[2][30])
            {
            }
            column(Trans_2__31_;Trans[2][31])
            {
            }
            column(TransAmt_2__31_;TransAmt[2][31])
            {
            }
            column(TransBal_2__31_;TransBal[2][31])
            {
            }
            column(Trans_2__32_;Trans[2][32])
            {
            }
            column(TransAmt_2__32_;TransAmt[2][32])
            {
            }
            column(TransBal_2__32_;TransBal[2][32])
            {
            }
            column(Trans_2__33_;Trans[2][33])
            {
            }
            column(TransAmt_2__33_;TransAmt[2][33])
            {
            }
            column(TransBal_2__33_;TransBal[2][33])
            {
            }
            column(Trans_2__34_;Trans[2][34])
            {
            }
            column(TransAmt_2__34_;TransAmt[2][34])
            {
            }
            column(TransBal_2__33__Control1102755268;TransBal[2][33])
            {
            }
            column(Trans_2__35_;Trans[2][35])
            {
            }
            column(TransAmt_2__35_;TransAmt[2][35])
            {
            }
            column(TransBal_2__35_;TransBal[2][35])
            {
            }
            column(Trans_2__36_;Trans[2][36])
            {
            }
            column(Trans_2__37_;Trans[2][37])
            {
            }
            column(TransAmt_2__36_;TransAmt[2][36])
            {
            }
            column(TransAmt_2__37_;TransAmt[2][37])
            {
            }
            column(TransBal_2__36_;TransBal[2][36])
            {
            }
            column(TransBal_2__37_;TransBal[2][37])
            {
            }
            column(Trans_2__38_;Trans[2][38])
            {
            }
            column(TransAmt_2__38_;TransAmt[2][38])
            {
            }
            column(TransBal_2__38_;TransBal[2][38])
            {
            }
            column(Trans_2__39_;Trans[2][39])
            {
            }
            column(TransAmt_2__39_;TransAmt[2][39])
            {
            }
            column(TransBal_2__39_;TransBal[2][39])
            {
            }
            column(Trans_2__40_;Trans[2][40])
            {
            }
            column(TransAmt_2__40_;TransAmt[2][40])
            {
            }
            column(TransBal_2__40_;TransBal[2][40])
            {
            }
            column(Trans_2__41_;Trans[2][41])
            {
            }
            column(TransAmt_2__41_;TransAmt[2][41])
            {
            }
            column(TransBal_2__41_;TransBal[2][41])
            {
            }
            column(Trans_2__42_;Trans[2][42])
            {
            }
            column(TransAmt_2__42_;TransAmt[2][42])
            {
            }
            column(TransBal_2__42_;TransBal[2][42])
            {
            }
            column(Trans_2__43_;Trans[2][43])
            {
            }
            column(TransAmt_2__43_;TransAmt[2][43])
            {
            }
            column(TransBal_2__43_;TransBal[2][43])
            {
            }
            column(Trans_2__44_;Trans[2][44])
            {
            }
            column(TransAmt_2__44_;TransAmt[2][44])
            {
            }
            column(TransBal_2__44_;TransBal[2][44])
            {
            }
            column(TransAmt_2__45_;TransAmt[2][45])
            {
            }
            column(Trans_2__45_;Trans[2][45])
            {
            }
            column(TransAmt_2__46_;TransAmt[2][46])
            {
            }
            column(Trans_2__46_;Trans[2][46])
            {
            }
            column(TransAmt_2__47_;TransAmt[2][47])
            {
            }
            column(TransAmt_2__48_;TransAmt[2][48])
            {
            }
            column(Trans_2__47_;Trans[2][47])
            {
            }
            column(Trans_2__48_;Trans[2][48])
            {
            }
            column(TransAmt_2__49_;TransAmt[2][49])
            {
            }
            column(Trans_2__49_;Trans[2][49])
            {
            }
            column(TransAmt_2__50_;TransAmt[2][50])
            {
            }
            column(TransAmt_2__51_;TransAmt[2][51])
            {
            }
            column(Trans_2__50_;Trans[2][50])
            {
            }
            column(Trans_2__51_;Trans[2][51])
            {
            }
            column(Trans_2__53_;Trans[2][53])
            {
            }
            column(TransAmt_1__52_;TransAmt[1][52])
            {
            }
            column(Trans_1__52_;Trans[1][52])
            {
            }
            column(TransAmt_2__52_;TransAmt[2][52])
            {
            }
            column(Trans_2__52_;Trans[2][52])
            {
            }
            column(Employee_Caption;Employee_CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(P_I_N_No_Caption;P_I_N_No_CaptionLbl)
            {
            }
            column(Employee_Caption_Control1102755158;Employee_Caption_Control1102755158Lbl)
            {
            }
            column(Department_Caption_Control1102755159;Department_Caption_Control1102755159Lbl)
            {
            }
            column(Period_Caption_Control1102755163;Period_Caption_Control1102755163Lbl)
            {
            }
            column(P_I_N_No_Caption_Control1102755165;P_I_N_No_Caption_Control1102755165Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755166;EmptyStringCaption_Control1102755166Lbl)
            {
            }
            column(BALANCECaption;BALANCECaptionLbl)
            {
            }
            column(AMOUNTCaption;AMOUNTCaptionLbl)
            {
            }
            column(AMOUNTCaption_Control1102755320;AMOUNTCaption_Control1102755320Lbl)
            {
            }
            column(BALANCECaption_Control1102755321;BALANCECaption_Control1102755321Lbl)
            {
            }
            column(prSalary_Card_Employee_Code;"Employee Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*PeriodTrans.RESET;
                PeriodTrans.SETRANGE(PeriodTrans."Employee Code","PRL-Salary Card"."Employee Code");
                PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SETRANGE(PeriodTrans."Transaction Code",'NPAY');
                IF PeriodTrans.FIND('-') =FALSE THEN
                 CurrReport.SKIP;*/
                
                emp1.Reset;
                emp1.SetRange(emp1."No.","PRL-Salary Card"."Employee Code");
                emp1.SetRange(emp1.Status,emp1.Status::Normal);
                if emp1.Find('-') then begin
                end;
                if ((ColumnNo=1) or (ColumnNo=0)) then begin ColumnNo:=ColumnNo+1;
                
                end else if ColumnNo=2  then begin ColumnNo:=1;end;
                
                //ColumnNo:=ColumnNo+1;
                
                strNssfNo:='. ';
                strNhifNo:='. ';
                strBank:='. ';
                strBranch:='. ';
                strAccountNo:='. ';
                strPin:='. ';
                /*CLEAR();
                CLEAR();
                CLEAR();
                CLEAR();
                CLEAR();
                CLEAR();
                CLEAR();
                CLEAR(); */
                
                RecordNo := RecordNo + 1;
                //IF ColumnNo=0 THEN ColumnNo := ColumnNo + 1;
                
                
                //Get the staff details (header)
                objEmp.SetRange(objEmp."No.","Employee Code");
                //objEmp.SETRANGE(objEmp.Status,objEmp.Status::normal);
                if objEmp.Find('-') then
                begin
                if  objEmp."Department Code" <> ''  then begin
                    Dimm.Reset;
                    Dimm.SetRange(Dimm."Dimension Code",'DEPARTMENT');
                    Dimm.SetRange(Dimm.Code,objEmp."Department Code");
                    if Dimm.Find('-') then begin
                     dept:=Dimm.Name;
                    end;
                end;
                   strEmpName:='['+objEmp."No."+'] '+objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                   strPin:=objEmp."PIN Number";
                   dtDOE:=objEmp."Date Of Join";
                   ///STATUS:=FORMAT(objEmp.Status);
                   "Served Notice Period" := objEmp."Served Notice Period";
                  // dept:=objEmp."Department Code";
                   if objEmp."Date Of Leaving"=0D then
                    dtOfLeaving:=Dmy2date(31,12,9999)
                   else
                    dtOfLeaving:=objEmp."Date Of Leaving";
                
                    strNssfNo:=objEmp."NSSF No.";
                    strNhifNo:=objEmp."NHIF No.";
                    strPin:=objEmp."PIN Number";
                
                //Get the staff banks in the payslip - Dennis ***************************************************
                  strBankno:=objEmp."Main Bank";
                  strBranchno:=objEmp."Branch Bank";
                  bankStruct.SetRange(bankStruct."Bank Code",strBankno);
                  bankStruct.SetRange(bankStruct."Branch Code",strBranchno);
                  if bankStruct.Find('-') then
                    begin
                      strAccountNo:=objEmp."Bank Account Number";
                      strBank:=bankStruct."Bank Name";
                      strBranch:=bankStruct."Branch Name";
                    end;
                //*************************************************************************************************
                
                end;
                
                
                /*If the Employee's Pay is suspended, OR  the guy is active DO NOT execute the following code
                *****************************************************************************************************/
                if ("Suspend Pay"=false) then
                begin
                  //CLEAR(objOcx);
                  strEmpCode:="Employee Code";
                  //objOcx.fnProcesspayroll(strEmpCode,dtDOE,"Basic Pay","Pays PAYE","Pays NSSF","Pays NHIF",SelectedPeriod,STATUS,
                 //dtOfLeaving,"Served Notice Period", dept);
                end;
                /******************************************************************************************************/
                
                //Clear headers
                Addr[ColumnNo][1] :='';
                Addr[ColumnNo][2] :='';
                Addr[ColumnNo][3] :='';
                Addr[ColumnNo][4] :='';
                Addr[ColumnNo][5] :='';
                Addr[ColumnNo][6] :='';
                Addr[ColumnNo][7] :='';
                Addr[ColumnNo][8] :='';
                Addr[ColumnNo][9] :='';
                Addr[ColumnNo][10] :='';
                
                
                
                //Clear previous Transaction entries 53
                for intRow:=1 to 53 do
                begin
                  Trans[ColumnNo,intRow]:='';
                  TransAmt[ColumnNo,intRow]:='';
                  TransBal[ColumnNo,intRow]:='';
                end;
                
                //Loop through the transactions
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Company Deduction",false);         //dennis to filter our company deductions
                
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                
                
                //Addr[ColumnNo][1] := FORMAT(strEmpName);
                //Addr[ColumnNo][2] := dept; //Depart
                //Addr[ColumnNo][3] := PeriodName; //Period
                //Addr[ColumnNo][4] := strPin; //Pin
                Addr[ColumnNo][1] := Format(strEmpName);
                Addr[ColumnNo][2] := dept; //Depart
                Addr[ColumnNo][3] := PeriodName; //Period
                //Addr[ColumnNo][4] := strPin; //Pin
                
                /*Fill-in the other staff information
                *******************************************************************************/
                //Index+=1;
                Addr[ColumnNo,4]:='...................EMPLOYEE DETAILS...................';
                //EVALUATE(TransAmt[ColumnNo,Index],'......................................');
                
                //Index+=1;
                //Addr[ColumnNo,5]:='Staff Information:';
                //EVALUATE(TransAmt[ColumnNo,Index],'.');
                
                //N.S.S.F No:
                //Index+=1;
                Addr[ColumnNo,5]:='N.S.S.F No:   '+strNssfNo;
                Addr[ColumnNo,6]:='N.H.I.F No:   '+strNhifNo;
                Addr[ColumnNo,7]:='Bank:       '+strBank;
                Addr[ColumnNo,8]:='Branch:     '+strBranch;
                Addr[ColumnNo,9]:='Account No:   '+strAccountNo;
                Addr[ColumnNo,10]:='PIN:                '+strPin;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strNssfNo));
                //N.H.I.F No:
                //Index+=1;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strNhifNo));
                //Bank:
                //Index+=1;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strBank));
                //Branch:
                //Index+=1;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strBranch));
                //Account No:
                //Index+=1;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strAccountNo));
                //Account No:
                //Index+=1;
                //EVALUATE(TransAmt[ColumnNo,Index],FORMAT(strPin));
                // Authorities
                /*//Index+=3;
                Addr[ColumnNo,Index]:='Checked By: Name:';
                EVALUATE(TransAmt[ColumnNo,Index],FORMAT('-----------------------------------------'));
                
                Index+=2;
                Addr[ColumnNo,Index]:='Signature';
                EVALUATE(TransAmt[ColumnNo,Index],FORMAT('-----------------------------------------'));
                Index+=2;
                Addr[ColumnNo,Index]:='Designation';
                EVALUATE(TransAmt[ColumnNo,Index],FORMAT('-----------------------------------------'));
                 */
                
                
                
                
                
                Index:=1;
                strGrpText:='';
                if PeriodTrans.Find('-') then
                    repeat
                
                         //Check if the group has changed
                         if strGrpText<>PeriodTrans."Group Text" then
                         begin
                            if PeriodTrans."Group Order"<>1 then
                            begin
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:='............................................................';
                              TransAmt[ColumnNo,Index]:='.........................................................';
                            //  TransBal[ColumnNo,Index]:='......................................';
                            end;
                
                            if (PeriodTrans."Group Text"<>'BASIC SALARY') and (PeriodTrans."Group Text"<>'GROSS PAY') and
                            (PeriodTrans."Group Text"<>'NET PAY') then begin
                              Index:=Index+1;
                              strGrpText:=PeriodTrans."Group Text";
                
                              Trans[ColumnNo,Index]:=strGrpText;
                              TransAmt[ColumnNo,Index]:='.';
                            //  TransBal[ColumnNo,Index]:='.';
                           end;
                
                           // IF PeriodTrans.Amount>0 THEN
                           // BEGIN
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Amount));
                
                           //   IF PeriodTrans.Balance=0 THEN
                             //  EVALUATE(TransBal[ColumnNo,Index],FORMAT('                           .'))
                            //  ELSE
                             //  EVALUATE(TransBal[ColumnNo,Index],FORMAT(PeriodTrans.Balance));
                           // END;
                
                         end else
                         begin
                          //  IF PeriodTrans.Amount>0 THEN
                          //  BEGIN
                
                           if (PeriodTrans."Group Text"<>'BASIC SALARY') and (PeriodTrans."Group Text"<>'GROSS PAY')
                                       and (PeriodTrans."Group Text"<>'NET PAY') then begin
                
                              Index:=Index+1;
                              strGrpText:=PeriodTrans."Group Text";
                
                              Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Amount));
                
                             // IF PeriodTrans.Balance=0 THEN
                            //   EVALUATE(TransBal[ColumnNo,Index],FORMAT('                           .'))
                            //  ELSE
                             //  EVALUATE(TransBal[ColumnNo,Index],FORMAT(PeriodTrans.Balance));
                            end;
                         end;
                         PeriodTrans.CalcFields(PeriodTrans."Total Statutories");
                         if PeriodTrans."Transaction Code"='TOT-DED' then
                       //  error('Test');
                         Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Amount+PeriodTrans."Total Statutories"));
                
                    until PeriodTrans.Next=0;
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:='................................................................';
                              TransAmt[ColumnNo,Index]:='...........................................................';
                
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:='                                          ';
                              TransAmt[ColumnNo,Index]:='                                       ';
                
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:='EMPLOYEE INFORMATION...................................';
                              TransAmt[ColumnNo,Index]:='...........................................................';
                
                             // Index:=Index+1;
                             // Trans[ColumnNo,Index]:='......................................';
                             // TransAmt[ColumnNo,Index]:='......................................';
                
                
                //Loop through the transactions FETCHING BALANCES
                
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Company Deduction",false);         //dennis to filter our company deductions
                PeriodTrans.SetFilter(PeriodTrans.Balance,'<>%1',0);
                
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                if PeriodTrans.Find('-') then begin
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                    repeat
                         //Check if the group has changed
                         if strGrpText<>PeriodTrans."Group Text" then
                         begin
                            if PeriodTrans."Group Order"<>1 then
                            begin
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:='............';
                              TransAmt[ColumnNo,Index]:='...................';
                              //TransBal[ColumnNo,Index2]:='......................................';
                            end;
                
                
                            if (PeriodTrans."Group Text"<>'BASIC SALARY') and (PeriodTrans."Group Text"<>'GROSS PAY') and
                            (PeriodTrans."Group Text"<>'NET PAY') then begin
                             // Index:=Index+1;
                              strGrpText:=PeriodTrans."Group Text";
                             // Trans[ColumnNo,Index]:=strGrpText;
                            //  TransAmt[ColumnNo,Index]:='.';
                             // TransBal[ColumnNo,Index]:='.';
                           end;
                
                           // IF PeriodTrans.Amount>0 THEN
                           // BEGIN
                
                           if PeriodTrans.Balance>0 then begin
                              Index:=Index+1;
                              Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Balance));
                           end;
                
                              // EVALUATE(TransBal[ColumnNo,Index],FORMAT('                           .'))
                             // ELSE
                             //  EVALUATE(TransBal[ColumnNo,Index],FORMAT(PeriodTrans.Balance));
                           // END;
                
                        end else
                         begin
                          //  IF PeriodTrans.Amount>0 THEN
                          //  BEGIN
                
                           if (PeriodTrans."Group Text"<>'BASIC SALARY') and (PeriodTrans."Group Text"<>'GROSS PAY')
                                       and (PeriodTrans."Group Text"<>'NET PAY') then begin
                         if PeriodTrans.Balance>0 then begin
                            PeriodTrans.CalcFields("Balance Type");
                              Index:=Index+1;
                
                              strGrpText:=PeriodTrans."Group Text";
                              Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                              if PeriodTrans."Balance Type"=PeriodTrans."balance type"::Increasing then
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Balance-PeriodTrans.Amount))
                              else
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Balance+PeriodTrans.Amount));
                
                              if PeriodTrans."Transaction Name"='Pension(Self)' then begin
                              //MEssage('LOL');
                              Trans[ColumnNo,Index]:='Pension Employer';
                              Evaluate(TransAmt[ColumnNo,Index],Format(ROUND(PeriodTrans.Amount*2,2,'=')));
                             // Index:=Index+1;
                            //  Trans[ColumnNo,Index]:='Pension(Self)';
                            //  EVALUATE(TransAmt[ColumnNo,Index],FORMAT(ROUND(PeriodTrans.Balance,2,'=')));
                
                              end;
                              if PeriodTrans."Transaction Name"='Provident (Self)' then begin
                              Trans[ColumnNo,Index]:='Provident Employer';
                              Evaluate(TransAmt[ColumnNo,Index],Format(ROUND("PRL-Salary Card"."Basic Pay"*0.1-200,2,'=')));
                            //  Index:=Index+1;
                            //  Trans[ColumnNo,Index]:='Provident (Self)';
                            //  EVALUATE(TransAmt[ColumnNo,Index],FORMAT(ROUND(PeriodTrans.Balance,2,'=')));
                
                              end;
                         end else begin
                              Index:=Index+1;
                
                              strGrpText:=PeriodTrans."Group Text";
                              Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                              Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Balance));
                
                              if PeriodTrans."Transaction Name"='Pension(Self)' then begin
                              Trans[ColumnNo,Index]:='Pension Employer';
                              Evaluate(TransAmt[ColumnNo,Index],Format(ROUND(PeriodTrans.Amount*2,2,'=')));
                
                              end; //
                              if PeriodTrans."Transaction Name"='Provident (Self)' then begin
                              Trans[ColumnNo,Index]:='Provident Employer';
                              Evaluate(TransAmt[ColumnNo,Index],Format(ROUND("PRL-Salary Card"."Basic Pay"*1-200,2,'=')));
                
                              end;
                
                
                         end;
                             //  EVALUATE(TransBal[ColumnNo,Index],FORMAT('                           .'))
                             // ELSE
                            //   EVALUATE(TransBal[ColumnNo,Index],FORMAT(PeriodTrans.Balance));
                            end;
                         end;
                  until PeriodTrans.Next=0;
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                end;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Group Order",8);         //dennis to filter our company deductions
                PeriodTrans.SetRange(PeriodTrans."Sub Group Order",0);
                
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                if PeriodTrans.Find('-') then begin
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                    repeat
                          /*
                         IF ((PeriodTrans."Group Text"='DEDUCTIONS') AND (PeriodTrans."Transaction Name"='Pension (Self)')) THEN BEGIN
                              Index:=Index+1;
                              strGrpText:='DEDUCTIONS';
                              Trans[ColumnNo,Index]:='Pension (Employer)';
                              EVALUATE(TransAmt[ColumnNo,Index],FORMAT(PeriodTrans.Amount*2));
                         END;
                         */
                         until PeriodTrans.Next =0;
                         end;
                
                
                //Payslip message - Denno
                Index+=1;
                ControlInfo.Reset;
                ControlInfo.SetRange(ControlInfo."Primary Key");
                if ControlInfo.Find('-') then
                begin
                 Trans[ColumnNo,Index]:=objPeriod."Payslip Message";
                end;
                //******************************************************************************
                
                
                //COMPRESSARRAY(Addr[ColumnNo]);
                //COMPRESSARRAY(Trans[ColumnNo]);
                //COMPRESSARRAY(TransAmt[ColumnNo]);
                //COMPRESSARRAY(TransBal[ColumnNo]);
                
                //IF ColumnNo>2 THEN BEGIN
                //CLEARALL;
                //END;
                  if ColumnNo> 1 then CurrReport.Skip;
                
                /*
                IF (RecordNo = NoOfRecords) AND (ColumnNo<3) THEN BEGIN
                  FOR i := ColumnNo + 1 TO NoOfColumns DO
                    BEGIN
                      CLEAR(Addr[i]);
                      CLEAR(Trans[i]);
                      CLEAR(TransAmt[i]);
                      CLEAR(TransBal[i]);
                    END;
                      ColumnNo := 0;
                
                END ELSE
                
                BEGIN
                  IF ColumnNo = NoOfColumns THEN
                    ColumnNo := 0;s
                
                END;*/
                
                if  ((Trans[1][5]='') and (Trans[2][5]='')) then CurrReport.Skip;

            end;

            trigger OnPreDataItem()
            begin



                objPeriod.Reset;
                if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";


                NoOfRecords := Count;
                NoOfColumns := 2;



                strNssfNo:='.';
                strNhifNo:='.';
                strBank:='.';
                strBranch:='.';
                strAccountNo:='.';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if ("PRL-Salary Card".GetFilter("PRL-Salary Card"."Payroll Period"))='' then Error('Specify a period filter.');
        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        if Evaluate(SelectedPeriod,("PRL-Salary Card".GetFilter("PRL-Salary Card"."Payroll Period"))) then;
    end;

    var
        emp1: Record UnknownRecord61118;
        Addr: array [2,10] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        intInfo: Integer;
        i: Integer;
        PeriodTrans: Record UnknownRecord61092;
        intRow: Integer;
        Index: Integer;
        objEmp: Record UnknownRecord61118;
        strEmpName: Text[250];
        strPin: Text[30];
        Trans: array [2,60] of Text[250];
        TransAmt: array [2,60] of Text[250];
        TransBal: array [2,60] of Text[250];
        strGrpText: Text[100];
        strNssfNo: Text[30];
        strNhifNo: Text[30];
        strBank: Text[100];
        strBranch: Text[100];
        strAccountNo: Text[100];
        strMessage: Text[100];
        PeriodName: Text[30];
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord61081;
        dtDOE: Date;
        strEmpCode: Text[30];
        STATUS: Text[30];
        ControlInfo: Record "Company Information";
        dtOfLeaving: Date;
        "Served Notice Period": Boolean;
        dept: Text[100];
        bankStruct: Record UnknownRecord61077;
        emploadva: Record UnknownRecord61092;
        strBankno: Text[30];
        strBranchno: Text[30];
        CompanyInfo: Record "Company Information";
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        Dimm: Record "Dimension Value";
        Employee_CaptionLbl: label 'Employee:';
        EmptyStringCaptionLbl: label '...........................................................................................';
        Department_CaptionLbl: label 'Department:';
        Period_CaptionLbl: label 'Period:';
        P_I_N_No_CaptionLbl: label '.............EMPLOYEE DETAIL..............';
        Employee_Caption_Control1102755158Lbl: label 'Employee:';
        Department_Caption_Control1102755159Lbl: label 'Department:';
        Period_Caption_Control1102755163Lbl: label 'Period:';
        P_I_N_No_Caption_Control1102755165Lbl: label 'P.I.N No:';
        EmptyStringCaption_Control1102755166Lbl: label '...........................................................................................';
        BALANCECaptionLbl: label 'BALANCE';
        AMOUNTCaptionLbl: label 'AMOUNT';
        AMOUNTCaption_Control1102755320Lbl: label 'AMOUNT';
        BALANCECaption_Control1102755321Lbl: label 'BALANCE';
}

