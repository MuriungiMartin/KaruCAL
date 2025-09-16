#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51125 "Overtime Claim"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Overtime Claim.rdlc';

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
            column(Payroll_Variations__Effective_Date_;"Effective Date")
            {
            }
            column(Names;Names)
            {
            }
            column(Payroll_Variations__Hrs_Worked_;"Hrs Worked")
            {
            }
            column(Payroll_Variations__Overtime_Type_;"Overtime Type")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Overtime_Claim_DetailsCaption;Overtime_Claim_DetailsCaptionLbl)
            {
            }
            column(Payroll_Variations__Employee_Code_Caption;FieldCaption("Employee Code"))
            {
            }
            column(Payroll_Variations__Payroll_Period_Caption;FieldCaption("Payroll Period"))
            {
            }
            column(Payroll_Variations__Effective_Date_Caption;FieldCaption("Effective Date"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(Payroll_Variations__Hrs_Worked_Caption;FieldCaption("Hrs Worked"))
            {
            }
            column(Payroll_Variations__Overtime_Type_Caption;FieldCaption("Overtime Type"))
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

            trigger OnAfterGetRecord()
            begin
                    Names:='';
                    if "Hr-Employee".Get("Employee Code") then
                      Names:="Hr-Employee"."First Name"+' '+"Hr-Employee"."Middle Name"+' '+"Hr-Employee"."Last Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Employee Code");
                "PRL-Payroll Variations".SetRange("PRL-Payroll Variations".Type, "PRL-Payroll Variations".Type::"Overtime Claim")
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
        "Hr-Employee": Record UnknownRecord61118;
        Names: Text[100];
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Overtime_Claim_DetailsCaptionLbl: label 'Overtime Claim Details';
        NamesCaptionLbl: label 'Names';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
}

