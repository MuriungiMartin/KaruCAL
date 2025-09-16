#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51122 "Payroll Variation Requests"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Variation Requests.rdlc';

    dataset
    {
        dataitem(UnknownTable61123;UnknownTable61123)
        {
            DataItemTableView = sorting("Employee Code");
            RequestFilterFields = "Employee Code";
            column(ReportForNavId_9162; 9162)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(Payroll_Variations__Employee_Code_;"Employee Code")
            {
            }
            column(Payroll_Variations__Payroll_Period_;"Payroll Period")
            {
            }
            column(Payroll_Variations_Type;Type)
            {
            }
            column(Payroll_Variations__Basic_Pay_;"Basic Pay")
            {
            }
            column(Payroll_Variations__Effective_Date_;"Effective Date")
            {
            }
            column(Payroll_Variations__Transaction_Code_;"Transaction Code")
            {
            }
            column(Payroll_Variations__New_Amount_;"New Amount")
            {
            }
            column(Payroll_Variations__Hrs_Worked_;"Hrs Worked")
            {
            }
            column(Payroll_Variations__Overtime_Type_;"Overtime Type")
            {
            }
            column(Payroll_Variations_Status;Status)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payroll_VariationsCaption;Payroll_VariationsCaptionLbl)
            {
            }
            column(Payroll_Variations__Employee_Code_Caption;FieldCaption("Employee Code"))
            {
            }
            column(Payroll_Variations__Payroll_Period_Caption;FieldCaption("Payroll Period"))
            {
            }
            column(Payroll_Variations_TypeCaption;FieldCaption(Type))
            {
            }
            column(Payroll_Variations__Basic_Pay_Caption;FieldCaption("Basic Pay"))
            {
            }
            column(Payroll_Variations__Effective_Date_Caption;FieldCaption("Effective Date"))
            {
            }
            column(Payroll_Variations__Transaction_Code_Caption;FieldCaption("Transaction Code"))
            {
            }
            column(Payroll_Variations__New_Amount_Caption;FieldCaption("New Amount"))
            {
            }
            column(Payroll_Variations__Hrs_Worked_Caption;FieldCaption("Hrs Worked"))
            {
            }
            column(Payroll_Variations__Overtime_Type_Caption;FieldCaption("Overtime Type"))
            {
            }
            column(Payroll_Variations_StatusCaption;FieldCaption(Status))
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Employee Code");
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
        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInfo: Record "Company Information";
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Payroll_VariationsCaptionLbl: label 'Payroll Variations';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
}

