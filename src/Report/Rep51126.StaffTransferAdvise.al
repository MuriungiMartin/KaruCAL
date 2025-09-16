#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51126 "Staff Transfer Advise"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Transfer Advise.rdlc';

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
            column(Payroll_Variations__Department_Code_;"Department Code")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Staff_Transfer_AdviseCaption;Staff_Transfer_AdviseCaptionLbl)
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
            column(Payroll_Variations__Department_Code_Caption;FieldCaption("Department Code"))
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
                "PRL-Payroll Variations".SetRange("PRL-Payroll Variations".Type, "PRL-Payroll Variations".Type::"New Employee")
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
        Staff_Transfer_AdviseCaptionLbl: label 'Staff Transfer Advise';
        NamesCaptionLbl: label 'Names';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
}

