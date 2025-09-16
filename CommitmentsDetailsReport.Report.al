#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51313 "Commitments Details Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Commitments Details Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61184;UnknownTable61184)
        {
            DataItemTableView = sorting("Entry No");
            RequestFilterFields = Department,"G/L Account";
            column(ReportForNavId_2731; 2731)
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
            column(Expenditure_Buffer_No;No)
            {
            }
            column(Expenditure_Buffer__Posting_Date_;"Posting Date")
            {
            }
            column(Expenditure_Buffer_Type;Type)
            {
            }
            column(Expenditure_Buffer_Description;Description)
            {
            }
            column(Expenditure_Buffer_Amount;Amount)
            {
            }
            column(Expenditure_Buffer_Department;Department)
            {
            }
            column(Expenditure_Buffer__G_L_Account_;"G/L Account")
            {
            }
            column(Expenditure_Buffer_Amount_Control1102760010;Amount)
            {
            }
            column(Committment_ReportCaption;Committment_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Expenditure_Buffer_NoCaption;FieldCaption(No))
            {
            }
            column(Expenditure_Buffer__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Expenditure_Buffer_TypeCaption;FieldCaption(Type))
            {
            }
            column(Expenditure_Buffer_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Expenditure_Buffer_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Expenditure_Buffer_DepartmentCaption;FieldCaption(Department))
            {
            }
            column(Expenditure_Buffer__G_L_Account_Caption;FieldCaption("G/L Account"))
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Expenditure_Buffer_Entry_No;"Entry No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  if "FIN-Expenditure Buffer".Amount=0 then CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                  "Populate Buffer";
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
        Balance: Decimal;
        Allocation: Decimal;
        Transfer: Decimal;
        Exp: Decimal;
        BudgetEntry: Record "G/L Budget Entry";
        "G/LEntry": Record "G/L Entry";
        Commitment: Decimal;
        GenSetup: Record "General Ledger Setup";
        ImprestDetails: Record UnknownRecord61126;
        Payments: Record UnknownRecord61134;
        CommRec: Record UnknownRecord61135;
        SRN: Record UnknownRecord61148;
        "SRN Line": Record UnknownRecord61149;
        LineNo: Integer;
        ExpBuffrer: Record UnknownRecord61184;
        "GL ACC": Record "G/L Account";
        VoteEntry: Boolean;
        Committment_ReportCaptionLbl: label 'Committment Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_AmountCaptionLbl: label 'Total Amount';


    procedure "Populate Buffer"()
    begin

        GenSetup.Get;
        if ExpBuffrer.Find('-') then begin
        ExpBuffrer.DeleteAll;
        end;
        // Get Commitemnets
           Exp:=0;
           Payments.Reset;
           Payments.SetRange(Payments.Posted,false);
           Payments.SetFilter(Payments.Date,'%1..%2',GenSetup."Current Budget Start Date",GenSetup."Current Budget End Date");
           Payments.SetFilter(Payments.Department,"FIN-Expenditure Buffer".GetFilter("FIN-Expenditure Buffer".Department));
           if Payments.Find('-') then begin
           repeat
             if Payments.Posted=false then begin
              ImprestDetails.Reset;
              ImprestDetails.SetFilter(ImprestDetails.No,Payments.No);
              ImprestDetails.SetFilter(ImprestDetails."Account No:","FIN-Expenditure Buffer".GetFilter("FIN-Expenditure Buffer"."G/L Account"));
              if ImprestDetails.Find('-') then begin
                repeat
                if "GL ACC".Get(ImprestDetails."Account No:") then begin
                  VoteEntry:="GL ACC"."Budget Controlled"
                end;
                if VoteEntry=true then begin
                  LineNo:=LineNo+1;
                  Exp:=Exp+ImprestDetails.Amount;
                  "FIN-Expenditure Buffer".Init;
                  "FIN-Expenditure Buffer"."Entry No":=LineNo;
                  "FIN-Expenditure Buffer".No:=ImprestDetails.No;
                  "FIN-Expenditure Buffer"."Posting Date":=Payments."Date Posted";
                  "FIN-Expenditure Buffer".Type:=Format(Payments."Payment Type");
                  "FIN-Expenditure Buffer".Description:=ImprestDetails."Account Name";
                  "FIN-Expenditure Buffer".Amount:=ImprestDetails.Amount;
                  "FIN-Expenditure Buffer".Department:=Payments.Department;
                  "FIN-Expenditure Buffer"."G/L Account":=ImprestDetails."Account No:";
                  "FIN-Expenditure Buffer".Insert;
                end;
                until ImprestDetails.Next=0;
              end;
            end;
            until Payments.Next=0;
           end;
    end;
}

