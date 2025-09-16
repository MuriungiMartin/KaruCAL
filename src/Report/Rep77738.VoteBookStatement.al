#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77738 "Vote Book Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vote Book Statement.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.","Date Filter","Budget Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Filt;Filt)
            {
            }
            column(Filt2;Filt2)
            {
            }
            column(G_L_Account__No__;"No.")
            {
            }
            column(G_L_Account_Name;Name)
            {
            }
            column(Allocation;Allocation)
            {
            }
            column(Transfer;Transfer)
            {
            }
            column(Commitment;Commitment)
            {
            }
            column(Exp;Exp)
            {
            }
            column(G_L_Account_Balance;Balance)
            {
            }
            column(GrandAll;GrandAll)
            {
            }
            column(GrandTran;GrandTran)
            {
            }
            column(GrandCom;GrandCom)
            {
            }
            column(GrandExp;GrandExp)
            {
            }
            column(bal;bal)
            {
            }
            column(VOTE_BOOK_SUMMARYCaption;VOTE_BOOK_SUMMARYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Account__No__Caption;FieldCaption("No."))
            {
            }
            column(G_L_Account_NameCaption;FieldCaption(Name))
            {
            }
            column(AllocationCaption;AllocationCaptionLbl)
            {
            }
            column(Transfers_AmountCaption;Transfers_AmountCaptionLbl)
            {
            }
            column(Commitment_AmountCaption;Commitment_AmountCaptionLbl)
            {
            }
            column(ExpendictureCaption;ExpendictureCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(BalPerc;"Bal%")
            {
            }
            column(GlobalDimension2Code_GLAccount;"G/L Account"."Global Dimension 2 Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                // Get Allocations
                   bal:=0;
                   Exp:=0;
                    Allocation:=0;
                    "G/L Account".CalcFields("G/L Account"."Budgeted Amount");
                    "G/L Account".CalcFields("G/L Account"."Net Change");
                     Allocation:="G/L Account"."Budgeted Amount";
                     Exp:=Abs("G/L Account"."Net Change");
                 // Get Transfers

                    Transfer:=0;
                    BudgetEntry.Reset;
                    BudgetEntry.SetFilter(BudgetEntry."G/L Account No.","G/L Account"."No.");
                    BudgetEntry.SetFilter(BudgetEntry.Date,'%1..%2',GenSetup."Current Budget Start Date",GenSetup."Current Budget End Date");
                    if FilterUser then
                       BudgetEntry.SetFilter(BudgetEntry."Budget Dimension 1 Code",UserDept)
                    else
                      BudgetEntry.SetFilter(BudgetEntry."Budget Dimension 1 Code","G/L Account".GetFilter(
                      "G/L Account"."Global Dimension 2 Filter"));
                    if BudgetEntry.Find('-') then begin
                      repeat
                      if BudgetEntry.Amount<0 then
                       Transfer:=Transfer+ Abs(BudgetEntry.Amount);
                     until BudgetEntry.Next=0;
                    end;

                  // Get Commitments
                  Commitment:=0;
                  CommRec.Reset;
                  CommRec.SetFilter(CommRec."G/L Account No.","G/L Account"."No.");
                  //CommRec.SETRANGE(CommRec.Closed,FALSE);
                 // IF FilterUser THEN
                   //CommRec.SETFILTER(CommRec.Department,UserDept)
                 // ELSE
                  CommRec.SetFilter(CommRec."Shortcut Dimension 1 Code","G/L Account".GetFilter("G/L Account"."Global Dimension 2 Filter"));

                  if CommRec.Find('-') then begin
                     repeat
                     if (CommRec.Date>GenSetup."Current Budget Start Date") and (CommRec.Date<GenSetup."Current Budget End Date") then
                     Commitment:=CommRec.Amount+Commitment;
                     until CommRec.Next=0;
                  end;
                  GrandAll:=0;
                  GrandExp:=0;
                   Balance:=Allocation-(Transfer+Exp+Commitment);
                   GrandExp:=GrandExp+Exp;
                   GrandAll:=GrandAll+Allocation;
                   GrandTran:=GrandTran+Transfer;
                   GrandCom:=GrandCom+Commitment;
                   GrandBal:=GrandAll-(GrandTran+GrandExp+GrandCom);

                bal:=bal+GrandBal;
                if ((Transfer+Exp+Commitment)<>0) and (Allocation<>0) then
                "Bal%":=((Transfer+Exp+Commitment)/Allocation);
                //IF bal<1 THEN
                //"Bal%":=0;
                   if (Allocation=0) then //AND (Transfer=0) AND (Exp=0) AND (Commitment=0) THEN
                      CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                  GenSetup.Get;
                  /*
                // Get User Department HOD
                  UserResp.RESET;
                  UserResp.SETRANGE(UserResp."Login Name",USERID);
                  IF UserResp.FIND('-') THEN BEGIN
                    UserDept:=UserResp.Department
                  END;
                 IF FilterUser THEN
                  Filt:='Department: '+UserDept
                 ELSE
                 Filt:='Department: '+"G/L Account".GETFILTER("G/L Account"."Global Dimension 2 Filter");
                 */
                if "G/L Account".GetFilter("G/L Account"."No.")<>'' then
                  Filt2:='G/L ACCOUNT NO:   '+"G/L Account".GetFilter("G/L Account"."No.");
                
                //IF "G/L Account".GETFILTER("G/L Account"."Global Dimension 2 Filter")='000' THEN
                //"G/L Account".SETFILTER("G/L Account"."Global Dimension 2 Filter",'%1|%2','','000');
                
                SetFilter("G/L Account"."Date Filter",'%1..%2',GenSetup."Current Budget Start Date",GenSetup."Current Budget End Date");
                
                

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000001)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Balance: Decimal;
        Allocation: Decimal;
        Transfer: Decimal;
        Exp: Decimal;
        BudgetEntry: Record "G/L Budget Entry";
        "G/LEntry": Record "G/L Entry";
        Commitment: Decimal;
        GenSetup: Record UnknownRecord61713;
        ImprestDetails: Record UnknownRecord61704;
        Payments: Record UnknownRecord61688;
        CommRec: Record UnknownRecord61722;
        SRN: Record UnknownRecord61722;
        "SRN Line": Record UnknownRecord61724;
        GrandExp: Decimal;
        GrandAll: Decimal;
        GrandTran: Decimal;
        GrandBal: Decimal;
        GrandCom: Decimal;
        UserResp: Record UnknownRecord61695;
        UserDept: Code[20];
        FilterUser: Boolean;
        Filt: Text[200];
        Filt2: Text[200];
        bal: Decimal;
        "Bal%": Decimal;
        VOTE_BOOK_SUMMARYCaptionLbl: label 'VOTE BOOK SUMMARY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        AllocationCaptionLbl: label 'Allocation';
        Transfers_AmountCaptionLbl: label 'Transfers Amount';
        Commitment_AmountCaptionLbl: label 'Commitment Amount';
        ExpendictureCaptionLbl: label 'Expendicture';
        BalanceCaptionLbl: label 'Balance';
        TotalsCaptionLbl: label 'Totals';
}

