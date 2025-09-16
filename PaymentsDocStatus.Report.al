#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51288 "Payments Doc Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payments Doc Status.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No,"IW No","Payment Type",OPN,"Account No.",Department;
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
            column(Payments_No;No)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(Payments_Status;Status)
            {
            }
            column(Payments__Checked_On_;"Checked On")
            {
            }
            column(Payments__Approved_Date_;"Approved Date")
            {
            }
            column(Payments__Date_Posted_;"Date Posted")
            {
            }
            column(Payments__Payment_Type_;"Payment Type")
            {
            }
            column(Payments__Pay_Mode_;"Pay Mode")
            {
            }
            column(Payments_Documents_StatusCaption;Payments_Documents_StatusCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Payments__IW_No_Caption;FieldCaption("IW No"))
            {
            }
            column(Payments_StatusCaption;FieldCaption(Status))
            {
            }
            column(Payments__Checked_On_Caption;FieldCaption("Checked On"))
            {
            }
            column(Payments__Approved_Date_Caption;FieldCaption("Approved Date"))
            {
            }
            column(Payments__Date_Posted_Caption;FieldCaption("Date Posted"))
            {
            }
            column(Payments__Payment_Type_Caption;FieldCaption("Payment Type"))
            {
            }
            column(Payments__Pay_Mode_Caption;FieldCaption("Pay Mode"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                 if "FIN-Payments".Status ="FIN-Payments".Status::New then
                 DocLevel:='User Level';
                 if "FIN-Payments".Status="FIN-Payments".Status::"1st Approval" then
                 DocLevel:='Approval';
                 if "FIN-Payments".Status="FIN-Payments".Status::"2nd Approval" then
                 DocLevel:='Audit';
                 if "FIN-Payments".Status="FIN-Payments".Status::"5th Approval" then
                 DocLevel:='Paid';
                 if "FIN-Payments".Status="FIN-Payments".Status::"6th Approval" then
                 DocLevel:='Surrendered';
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
        DocLevel: Code[20];
        Payments_Documents_StatusCaptionLbl: label 'Payments Documents Status';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

