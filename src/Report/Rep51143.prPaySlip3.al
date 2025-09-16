#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51143 prPaySlip3
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prPaySlip3.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("Department Code") order(ascending) where(Status=filter(Normal));
            column(ReportForNavId_8631; 8631)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756032;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102755009;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756027;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756028;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102755016;COMPANYNAME)
            {
            }
            column(HR_Employee_No_;"No.")
            {
            }
            dataitem(UnknownTable61105;UnknownTable61105)
            {
                DataItemLink = "Employee Code"=field("No.");
                DataItemTableView = sorting("Employee Code") order(ascending);
                RequestFilterFields = "Employee Code","Period Filter";
                column(ReportForNavId_6207; 6207)
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
                column(Addr_1__1_;Addr[1][1])
                {
                }
                column(Addr_1__2_;Addr[1][2])
                {
                }
                column(Addr_1__3_;Addr[1][3])
                {
                }
                column(Addr_1__4_;Addr[1][4])
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
                column(Addr_2__1_;Addr[2][1])
                {
                }
                column(Addr_2__2_;Addr[2][2])
                {
                }
                column(Addr_2__3_;Addr[2][3])
                {
                }
                column(Addr_2__4_;Addr[2][4])
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
                column(TransBal_2__33__Control1102756281;TransBal[2][33])
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
                column(Addr_3__1_;Addr[3][1])
                {
                }
                column(Addr_3__2_;Addr[3][2])
                {
                }
                column(Addr_3__3_;Addr[3][3])
                {
                }
                column(Addr_3__4_;Addr[3][4])
                {
                }
                column(TransBal_3__1_;TransBal[3][1])
                {
                }
                column(TransBal_3__2_;TransBal[3][2])
                {
                }
                column(TransBal_3__3_;TransBal[3][3])
                {
                }
                column(TransBal_3__4_;TransBal[3][4])
                {
                }
                column(TransBal_3__5_;TransBal[3][5])
                {
                }
                column(TransBal_3__6_;TransBal[3][6])
                {
                }
                column(TransBal_3__7_;TransBal[3][7])
                {
                }
                column(TransBal_3__8_;TransBal[3][8])
                {
                }
                column(TransBal_3__9_;TransBal[3][9])
                {
                }
                column(TransBal_3__10_;TransBal[3][10])
                {
                }
                column(TransBal_3__11_;TransBal[3][11])
                {
                }
                column(TransBal_3__12_;TransBal[3][12])
                {
                }
                column(TransBal_3__13_;TransBal[3][13])
                {
                }
                column(TransBal_3__14_;TransBal[3][14])
                {
                }
                column(TransBal_3__15_;TransBal[3][15])
                {
                }
                column(TransBal_3__16_;TransBal[3][16])
                {
                }
                column(TransBal_3__17_;TransBal[3][17])
                {
                }
                column(TransBal_3__18_;TransBal[3][18])
                {
                }
                column(TransBal_3__19_;TransBal[3][19])
                {
                }
                column(TransBal_3__20_;TransBal[3][20])
                {
                }
                column(TransBal_3__21_;TransBal[3][21])
                {
                }
                column(TransBal_3__22_;TransBal[3][22])
                {
                }
                column(TransBal_3__23_;TransBal[3][23])
                {
                }
                column(TransBal_3__24_;TransBal[3][24])
                {
                }
                column(TransBal_3__25_;TransBal[3][25])
                {
                }
                column(TransBal_3__26_;TransBal[3][26])
                {
                }
                column(TransBal_3__27_;TransBal[3][27])
                {
                }
                column(TransBal_3__28_;TransBal[3][28])
                {
                }
                column(TransBal_3__29_;TransBal[3][29])
                {
                }
                column(TransBal_3__30_;TransBal[3][30])
                {
                }
                column(TransBal_3__31_;TransBal[3][31])
                {
                }
                column(TransBal_3__32_;TransBal[3][32])
                {
                }
                column(TransBal_3__33_;TransBal[3][33])
                {
                }
                column(TransBal_3__33__Control1102755111;TransBal[3][33])
                {
                }
                column(TransBal_3__35_;TransBal[3][35])
                {
                }
                column(TransBal_3__36_;TransBal[3][36])
                {
                }
                column(TransBal_3__37_;TransBal[3][37])
                {
                }
                column(TransBal_3__38_;TransBal[3][38])
                {
                }
                column(TransBal_3__39_;TransBal[3][39])
                {
                }
                column(TransBal_3__40_;TransBal[3][40])
                {
                }
                column(TransBal_3__41_;TransBal[3][41])
                {
                }
                column(TransBal_3__42_;TransBal[3][42])
                {
                }
                column(TransBal_3__43_;TransBal[3][43])
                {
                }
                column(TransBal_3__44_;TransBal[3][44])
                {
                }
                column(Trans_3__53_;Trans[3][53])
                {
                }
                column(TransAmt_3__1_;TransAmt[3][1])
                {
                }
                column(TransAmt_3__2_;TransAmt[3][2])
                {
                }
                column(TransAmt_3__3_;TransAmt[3][3])
                {
                }
                column(TransAmt_3__4_;TransAmt[3][4])
                {
                }
                column(TransAmt_3__5_;TransAmt[3][5])
                {
                }
                column(TransAmt_3__6_;TransAmt[3][6])
                {
                }
                column(TransAmt_3__7_;TransAmt[3][7])
                {
                }
                column(TransAmt_3__8_;TransAmt[3][8])
                {
                }
                column(TransAmt_3__9_;TransAmt[3][9])
                {
                }
                column(TransAmt_3__10_;TransAmt[3][10])
                {
                }
                column(TransAmt_3__11_;TransAmt[3][11])
                {
                }
                column(TransAmt_3__12_;TransAmt[3][12])
                {
                }
                column(TransAmt_3__13_;TransAmt[3][13])
                {
                }
                column(TransAmt_3__14_;TransAmt[3][14])
                {
                }
                column(TransAmt_3__15_;TransAmt[3][15])
                {
                }
                column(TransAmt_3__16_;TransAmt[3][16])
                {
                }
                column(TransAmt_3__17_;TransAmt[3][17])
                {
                }
                column(TransAmt_3__18_;TransAmt[3][18])
                {
                }
                column(TransAmt_3__19_;TransAmt[3][19])
                {
                }
                column(TransAmt_3__20_;TransAmt[3][20])
                {
                }
                column(TransAmt_3__21_;TransAmt[3][21])
                {
                }
                column(TransAmt_3__22_;TransAmt[3][22])
                {
                }
                column(TransAmt_3__23_;TransAmt[3][23])
                {
                }
                column(TransAmt_3__24_;TransAmt[3][24])
                {
                }
                column(TransAmt_3__25_;TransAmt[3][25])
                {
                }
                column(TransAmt_3__26_;TransAmt[3][26])
                {
                }
                column(TransAmt_3__27_;TransAmt[3][27])
                {
                }
                column(TransAmt_3__28_;TransAmt[3][28])
                {
                }
                column(TransAmt_3__29_;TransAmt[3][29])
                {
                }
                column(TransAmt_3__30_;TransAmt[3][30])
                {
                }
                column(TransAmt_3__31_;TransAmt[3][31])
                {
                }
                column(TransAmt_3__32_;TransAmt[3][32])
                {
                }
                column(TransAmt_3__33_;TransAmt[3][33])
                {
                }
                column(TransAmt_3__34_;TransAmt[3][34])
                {
                }
                column(TransAmt_3__35_;TransAmt[3][35])
                {
                }
                column(TransAmt_3__36_;TransAmt[3][36])
                {
                }
                column(TransAmt_3__37_;TransAmt[3][37])
                {
                }
                column(TransAmt_3__38_;TransAmt[3][38])
                {
                }
                column(TransAmt_3__39_;TransAmt[3][39])
                {
                }
                column(TransAmt_3__40_;TransAmt[3][40])
                {
                }
                column(TransAmt_3__41_;TransAmt[3][41])
                {
                }
                column(TransAmt_3__42_;TransAmt[3][42])
                {
                }
                column(TransAmt_3__43_;TransAmt[3][43])
                {
                }
                column(TransAmt_3__44_;TransAmt[3][44])
                {
                }
                column(TransAmt_3__45_;TransAmt[3][45])
                {
                }
                column(TransAmt_3__46_;TransAmt[3][46])
                {
                }
                column(TransAmt_3__47_;TransAmt[3][47])
                {
                }
                column(TransAmt_3__48_;TransAmt[3][48])
                {
                }
                column(TransAmt_3__49_;TransAmt[3][49])
                {
                }
                column(TransAmt_3__50_;TransAmt[3][50])
                {
                }
                column(TransAmt_3__51_;TransAmt[3][51])
                {
                }
                column(TransAmt_3__52_;TransAmt[3][52])
                {
                }
                column(Trans_3__1_;Trans[3][1])
                {
                }
                column(Trans_3__2_;Trans[3][2])
                {
                }
                column(Trans_3__3_;Trans[3][3])
                {
                }
                column(Trans_3__4_;Trans[3][4])
                {
                }
                column(Trans_3__5_;Trans[3][5])
                {
                }
                column(Trans_3__6_;Trans[3][6])
                {
                }
                column(Trans_3__7_;Trans[3][7])
                {
                }
                column(Trans_3__8_;Trans[3][8])
                {
                }
                column(Trans_3__9_;Trans[3][9])
                {
                }
                column(Trans_3__10_;Trans[3][10])
                {
                }
                column(Trans_3__11_;Trans[3][11])
                {
                }
                column(Trans_3__12_;Trans[3][12])
                {
                }
                column(Trans_3__13_;Trans[3][13])
                {
                }
                column(Trans_3__14_;Trans[3][14])
                {
                }
                column(Trans_3__15_;Trans[3][15])
                {
                }
                column(Trans_3__16_;Trans[3][16])
                {
                }
                column(Trans_3__17_;Trans[3][17])
                {
                }
                column(Trans_3__18_;Trans[3][18])
                {
                }
                column(Trans_3__19_;Trans[3][19])
                {
                }
                column(Trans_3__20_;Trans[3][20])
                {
                }
                column(Trans_3__21_;Trans[3][21])
                {
                }
                column(Trans_3__22_;Trans[3][22])
                {
                }
                column(Trans_3__23_;Trans[3][23])
                {
                }
                column(Trans_3__24_;Trans[3][24])
                {
                }
                column(Trans_3__25_;Trans[3][25])
                {
                }
                column(Trans_3__26_;Trans[3][26])
                {
                }
                column(Trans_3__27_;Trans[3][27])
                {
                }
                column(Trans_3__28_;Trans[3][28])
                {
                }
                column(Trans_3__29_;Trans[3][29])
                {
                }
                column(Trans_3__30_;Trans[3][30])
                {
                }
                column(Trans_3__31_;Trans[3][31])
                {
                }
                column(Trans_3__32_;Trans[3][32])
                {
                }
                column(Trans_3__33_;Trans[3][33])
                {
                }
                column(Trans_3__34_;Trans[3][34])
                {
                }
                column(Trans_3__35_;Trans[3][35])
                {
                }
                column(Trans_3__36_;Trans[3][36])
                {
                }
                column(Trans_3__37_;Trans[3][37])
                {
                }
                column(Trans_3__38_;Trans[3][38])
                {
                }
                column(Trans_3__39_;Trans[3][39])
                {
                }
                column(Trans_3__40_;Trans[3][40])
                {
                }
                column(Trans_3__41_;Trans[3][41])
                {
                }
                column(Trans_3__42_;Trans[3][42])
                {
                }
                column(Trans_3__43_;Trans[3][43])
                {
                }
                column(Trans_3__44_;Trans[3][44])
                {
                }
                column(Trans_3__45_;Trans[3][45])
                {
                }
                column(Trans_3__46_;Trans[3][46])
                {
                }
                column(Trans_3__47_;Trans[3][47])
                {
                }
                column(Trans_3__48_;Trans[3][48])
                {
                }
                column(Trans_3__49_;Trans[3][49])
                {
                }
                column(Trans_3__50_;Trans[3][50])
                {
                }
                column(Trans_3__51_;Trans[3][51])
                {
                }
                column(Trans_3__52_;Trans[3][52])
                {
                }
                column(EmptyStringCaption;EmptyStringCaptionLbl)
                {
                }
                column(Emp_Caption;Emp_CaptionLbl)
                {
                }
                column(Dept_Caption;Dept_CaptionLbl)
                {
                }
                column(Period_Caption;Period_CaptionLbl)
                {
                }
                column(P_I_N_No_Caption;P_I_N_No_CaptionLbl)
                {
                }
                column(Emp_Caption_Control1102756171;Emp_Caption_Control1102756171Lbl)
                {
                }
                column(Dept_Caption_Control1102756172;Dept_Caption_Control1102756172Lbl)
                {
                }
                column(Period_Caption_Control1102756176;Period_Caption_Control1102756176Lbl)
                {
                }
                column(P_I_N_No_Caption_Control1102756178;P_I_N_No_Caption_Control1102756178Lbl)
                {
                }
                column(EmptyStringCaption_Control1102756179;EmptyStringCaption_Control1102756179Lbl)
                {
                }
                column(EmptyStringCaption_Control1102755023;EmptyStringCaption_Control1102755023Lbl)
                {
                }
                column(Emp__Caption;Emp__CaptionLbl)
                {
                }
                column(Dept_Caption_Control1102755302;Dept_Caption_Control1102755302Lbl)
                {
                }
                column(Period_Caption_Control1102755303;Period_Caption_Control1102755303Lbl)
                {
                }
                column(P_I_N_No_Caption_Control1102755304;P_I_N_No_Caption_Control1102755304Lbl)
                {
                }
                column(prSalary_Card_Employee_Code;"Employee Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    strNssfNo:='. ';
                    strNhifNo:='. ';
                    strBank:='. ';
                    strBranch:='. ';
                    strAccountNo:='. ';
                    strPin:='. ';
                    
                    RecordNo := RecordNo + 1;
                    ColumnNo := ColumnNo + 1;
                    
                    //Get the staff details (header)
                    objEmp.SetRange(objEmp."No.","Employee Code");
                    if objEmp.Find('-') then
                    begin
                       strEmpName:='['+"Employee Code"+'] '+objEmp."Last Name"+' '+objEmp."First Name"+' '+objEmp."Middle Name";
                       strPin:=objEmp."PIN Number";
                       dtDOE:=objEmp."Date Of Join";
                       STATUS:=Format(objEmp.Status);
                       "Served Notice Period" := objEmp."Served Notice Period";
                       dept:=objEmp."Department Code";
                     // Get Dept Description
                        Dimm.Reset;
                        Dimm.SetRange(Dimm."Dimension Code",'DEPARTMENT');
                        Dimm.SetRange(Dimm.Code,dept);
                        if Dimm.Find('-') then
                        dept:=Dimm.Name;
                    
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
                    
                    
                    Addr[ColumnNo][1] := Format(strEmpName);
                    Addr[ColumnNo][2] := dept; //Depart
                    Addr[ColumnNo][3] := PeriodName; //Period
                    Addr[ColumnNo][4] := strPin; //Pin
                    
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
                                  Trans[ColumnNo,Index]:='......................................';
                                  TransAmt[ColumnNo,Index]:='......................................';
                                  TransBal[ColumnNo,Index]:='......................................';
                                end;
                    
                                Index:=Index+1;
                                strGrpText:=PeriodTrans."Group Text";
                                Trans[ColumnNo,Index]:=strGrpText;
                                TransAmt[ColumnNo,Index]:='.';
                                TransBal[ColumnNo,Index]:='.';
                    
                               // IF PeriodTrans.Amount>0 THEN
                               // BEGIN
                                  Index:=Index+1;
                                  Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                                  Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Amount));
                    
                                  if PeriodTrans.Balance=0 then
                                   Evaluate(TransBal[ColumnNo,Index],Format('                           .'))
                                  else
                                   Evaluate(TransBal[ColumnNo,Index],Format(PeriodTrans.Balance));
                               // END;
                    
                             end else
                             begin
                              //  IF PeriodTrans.Amount>0 THEN
                              //  BEGIN
                                  Index:=Index+1;
                                  strGrpText:=PeriodTrans."Group Text";
                                  Trans[ColumnNo,Index]:=PeriodTrans."Transaction Name";
                                  Evaluate(TransAmt[ColumnNo,Index],Format(PeriodTrans.Amount));
                    
                                  if PeriodTrans.Balance=0 then
                                   Evaluate(TransBal[ColumnNo,Index],Format('                           .'))
                                  else
                                   Evaluate(TransBal[ColumnNo,Index],Format(PeriodTrans.Balance));
                              //  END;
                             end;
                        until PeriodTrans.Next=0;
                    
                    /*Fill-in the other staff information
                    *******************************************************************************/
                    Index+=1;
                    Trans[ColumnNo,Index]:='......................................';
                    Evaluate(TransAmt[ColumnNo,Index],'......................................');
                    
                    Index+=1;
                    Trans[ColumnNo,Index]:='Staff Information:';
                    Evaluate(TransAmt[ColumnNo,Index],'.');
                    
                    //N.S.S.F No:
                    Index+=1;
                    Trans[ColumnNo,Index]:='N.S.S.F No:';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strNssfNo));
                    
                    //N.H.I.F No:
                    Index+=1;
                    Trans[ColumnNo,Index]:='N.H.I.F No:';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strNhifNo));
                    
                    //Bank:
                    Index+=1;
                    Trans[ColumnNo,Index]:='Bank:';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strBank));
                    
                    //Branch:
                    Index+=1;
                    Trans[ColumnNo,Index]:='Branch:';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strBranch));
                    
                    //Account No:
                    Index+=1;
                    Trans[ColumnNo,Index]:='Account No';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strAccountNo));
                    
                    //Account No:
                    Index+=1;
                    Trans[ColumnNo,Index]:='PIN No';
                    Evaluate(TransAmt[ColumnNo,Index],Format(strPin));
                    
                    //Payslip message - Denno
                    Index+=1;
                    ControlInfo.Reset;
                    ControlInfo.SetRange(ControlInfo."Primary Key");
                    if ControlInfo.Find('-') then
                    begin
                     Trans[ColumnNo,Index]:=ControlInfo."Payslip Message";
                    end;
                    //******************************************************************************
                    
                    
                    //COMPRESSARRAY(Addr[ColumnNo]);
                    //COMPRESSARRAY(Trans[ColumnNo]);
                    //COMPRESSARRAY(TransAmt[ColumnNo]);
                    //COMPRESSARRAY(TransBal[ColumnNo]);
                    
                    if (RecordNo = NoOfRecords) and (ColumnNo<3) then begin
                      for i := ColumnNo + 1 to NoOfColumns do
                        begin
                          Clear(Addr[i]);
                          Clear(Trans[i]);
                          Clear(TransAmt[i]);
                          Clear(TransBal[i]);
                        end;
                          ColumnNo := 0;
                    
                    end else
                    
                    begin
                      if ColumnNo = NoOfColumns then
                        ColumnNo := 0;
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    NoOfRecords := Count;
                    NoOfColumns := 3;
                    
                    /*PeriodTrans.RESET;
                    PeriodTrans.SETRANGE(PeriodTrans."Employee Code","prSalary Card"."Employee Code");
                    PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                    PeriodTrans.SETRANGE(PeriodTrans."Transaction Code",'NPAY');
                    IF PeriodTrans.FIND('-') =FALSE THEN
                     CurrReport.SKIP;*/
                    
                    
                    strNssfNo:='.';
                    strNhifNo:='.';
                    strBank:='.';
                    strBranch:='.';
                    strAccountNo:='.';

                end;
            }
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
        PeriodFilter:="PRL-Salary Card".GetFilter("Period Filter");
        if PeriodFilter='' then Error('You must specify the period filter');

        SelectedPeriod:="PRL-Salary Card".GetRangeMin("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";



        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        Addr: array [3,10] of Text[250];
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
        Trans: array [3,60] of Text[250];
        TransAmt: array [3,60] of Text[250];
        TransBal: array [3,60] of Text[250];
        strGrpText: Text[100];
        strNssfNo: Text[30];
        strNhifNo: Text[30];
        strBank: Text[100];
        strBranch: Text[100];
        strAccountNo: Text[100];
        strMessage: Text[100];
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord61081;
        dtDOE: Date;
        strEmpCode: Text[30];
        STATUS: Text[30];
        ControlInfo: Record UnknownRecord61119;
        dtOfLeaving: Date;
        "Served Notice Period": Boolean;
        dept: Text[50];
        bankStruct: Record UnknownRecord61077;
        emploadva: Record UnknownRecord61115;
        strBankno: Text[30];
        strBranchno: Text[30];
        CompanyInfo: Record "Company Information";
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        Dimm: Record "Dimension Value";
        EmptyStringCaptionLbl: label '.....................................................................................................';
        Emp_CaptionLbl: label 'Emp:';
        Dept_CaptionLbl: label 'Dept:';
        Period_CaptionLbl: label 'Period:';
        P_I_N_No_CaptionLbl: label 'P.I.N No:';
        Emp_Caption_Control1102756171Lbl: label 'Emp:';
        Dept_Caption_Control1102756172Lbl: label 'Dept:';
        Period_Caption_Control1102756176Lbl: label 'Period:';
        P_I_N_No_Caption_Control1102756178Lbl: label 'P.I.N No:';
        EmptyStringCaption_Control1102756179Lbl: label '.....................................................................................................';
        EmptyStringCaption_Control1102755023Lbl: label '.....................................................................................................';
        Emp__CaptionLbl: label 'Emp: ';
        Dept_Caption_Control1102755302Lbl: label 'Dept:';
        Period_Caption_Control1102755303Lbl: label 'Period:';
        P_I_N_No_Caption_Control1102755304Lbl: label 'P.I.N No:';
}

