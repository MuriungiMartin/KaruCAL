#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51299 "Imprest Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Details.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting("Account No.") where("Payment Type"=const(Imprest),Posted=const(Yes),Type=const(IMPREST),"Account Type"=const(Customer));
            RequestFilterFields = "Account No.",Date,"IW No",Department,"Raised By","Checked By","Approved By";
            column(ReportForNavId_3752; 3752)
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
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_Payments_No;"FIN-Payments".No)
            {
            }
            column(PFName;PFName)
            {
            }
            column(Payments__Date_Posted_;"Date Posted")
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Purpose;Purpose)
            {
            }
            column(ActualSpent;ActualSpent)
            {
            }
            column(Bal;Bal)
            {
            }
            column(Cash;Cash)
            {
            }
            column(SurType;SurType)
            {
            }
            column(SurNo;SurNo)
            {
            }
            column(Payments_Amount_Control1102760029;Amount)
            {
            }
            column(GrpActual;GrpActual)
            {
            }
            column(GrpCash;GrpCash)
            {
            }
            column(GrpBal;GrpBal)
            {
            }
            column(Payments_Amount_Control1102760013;Amount)
            {
            }
            column(TotalActual;TotalActual)
            {
            }
            column(TotalCash;TotalCash)
            {
            }
            column(TotalBal;TotalBal)
            {
            }
            column(IMPREST_REGISTERCaption;IMPREST_REGISTERCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Doc_NoCaption;Doc_NoCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Payments__Date_Posted_Caption;FieldCaption("Date Posted"))
            {
            }
            column(Payments__IW_No_Caption;FieldCaption("IW No"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(PurposeCaption;PurposeCaptionLbl)
            {
            }
            column(Actual_SpentCaption;Actual_SpentCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(Cash_SurrCaption;Cash_SurrCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(Surr_NoCaption;Surr_NoCaptionLbl)
            {
            }
            column(PF_NOCaption;PF_NOCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(GRAND_TOTALSCaption;GRAND_TOTALSCaptionLbl)
            {
            }
            dataitem(UnknownTable61126;UnknownTable61126)
            {
                DataItemLink = No=field(No);
                column(ReportForNavId_3307; 3307)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                    ActualSpent:=0;
                    Cash:=0;
                    ImpDet.Reset;
                    ImpDet.SetRange(ImpDet.No,"FIN-Payments".No);
                    if ImpDet.Find('-') then begin
                       Purpose:=ImpDet."Account Name";
                       ActualSpent:=ActualSpent+ImpDet."Actual Spent";
                       Cash:=Cash+ImpDet."Cash Surrender Amt";
                       SurType:=Format(ImpDet."Type of Surrender");
                       SurNo:=ImpDet."Surrender Type No";
                    end;
                    Bal:="FIN-Payments".Amount-(ActualSpent+Cash);
                    PFName:="FIN-Payments"."Account Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Account No.");
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Purpose: Text[100];
        ImpDet: Record UnknownRecord61126;
        ActualSpent: Decimal;
        Bal: Decimal;
        TotalActual: Decimal;
        TotalBal: Decimal;
        GrpActual: Decimal;
        GrpBal: Decimal;
        GrpAmt: Decimal;
        TotalCash: Decimal;
        GrpCash: Decimal;
        Cash: Decimal;
        SurType: Code[50];
        SurNo: Code[20];
        PFName: Code[150];
        IMPREST_REGISTERCaptionLbl: label 'IMPREST REGISTER';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Doc_NoCaptionLbl: label 'Doc No';
        NameCaptionLbl: label 'Name';
        PurposeCaptionLbl: label 'Purpose';
        Actual_SpentCaptionLbl: label 'Actual Spent';
        BalanceCaptionLbl: label 'Balance';
        Cash_SurrCaptionLbl: label 'Cash Surr';
        TypeCaptionLbl: label 'Type';
        Surr_NoCaptionLbl: label 'Surr No';
        PF_NOCaptionLbl: label 'PF NO';
        TotalsCaptionLbl: label 'Totals';
        GRAND_TOTALSCaptionLbl: label 'GRAND TOTALS';
}

