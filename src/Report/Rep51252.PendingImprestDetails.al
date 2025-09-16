#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51252 "Pending Imprest Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pending Imprest Details.rdlc';

    dataset
    {
        dataitem(UnknownTable61126;UnknownTable61126)
        {
            DataItemTableView = sorting(No,"Account No:");
            RequestFilterFields = "Account No:","Imprest Holder","Due Date","Date Issued";
            column(ReportForNavId_3307; 3307)
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
            column(Imprest_Details_No;No)
            {
            }
            column(Imprest_Details__Account_No__;"Account No:")
            {
            }
            column(Imprest_Details__Imprest_Holder_;"Imprest Holder")
            {
            }
            column(Imprest_Details_Amount;Amount)
            {
            }
            column(Imprest_Details__Due_Date_;"Due Date")
            {
            }
            column(Imprest_Details__Date_Issued_;"Date Issued")
            {
            }
            column(PFName;PFName)
            {
            }
            column(Imprest_Details__Account_Name_;"Account Name")
            {
            }
            column(Pending_Imprest_DetailsCaption;Pending_Imprest_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Imprest_Details_NoCaption;FieldCaption(No))
            {
            }
            column(Imprest_Details__Account_No__Caption;FieldCaption("Account No:"))
            {
            }
            column(PF_NOCaption;PF_NOCaptionLbl)
            {
            }
            column(Imprest_Details_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Imprest_Details__Due_Date_Caption;FieldCaption("Due Date"))
            {
            }
            column(Imprest_Details__Date_Issued_Caption;FieldCaption("Date Issued"))
            {
            }
            column(Imprest_HolderCaption;Imprest_HolderCaptionLbl)
            {
            }
            column(Imprest_Details__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Imprest_Details_Line_No;"Line No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                   Cust.Reset;
                   PFName:='';
                   Cust.SetRange(Cust."No.","FIN-Imprest Details"."Imprest Holder");
                   if Cust.Find('-') then
                   begin
                     PFName:=Cust.Name
                   end;
            end;

            trigger OnPreDataItem()
            begin
                    "FIN-Imprest Details".SetRange("FIN-Imprest Details".Surrendered,false);
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
        PFName: Text[30];
        Cust: Record Customer;
        Pending_Imprest_DetailsCaptionLbl: label 'Pending Imprest Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PF_NOCaptionLbl: label 'PF NO';
        Imprest_HolderCaptionLbl: label 'Imprest Holder';
}

