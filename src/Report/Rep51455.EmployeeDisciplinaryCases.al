#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51455 "Employee Disciplinary Cases"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Disciplinary Cases.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372)
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
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C_Names;Names)
            {
            }
            column(Employee_Disciplinary_CasesCaption;Employee_Disciplinary_CasesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            dataitem(UnknownTable61299;UnknownTable61299)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_5186; 5186)
                {
                }
                column(Employee_Disciplinary_Cases__Refference_No_;"Refference No")
                {
                }
                column(Employee_Disciplinary_Cases_Date;Date)
                {
                }
                column(Employee_Disciplinary_Cases__Disciplinary_Case_;"Disciplinary Case")
                {
                }
                column(Employee_Disciplinary_Cases__Recommended_Action_;"Recommended Action")
                {
                }
                column(Employee_Disciplinary_Cases__Case_Description_;"Case Description")
                {
                }
                column(Employee_Disciplinary_Cases__Accused_Defence_;"Accused Defence")
                {
                }
                column(Employee_Disciplinary_Cases__Action_Taken_;"Action Taken")
                {
                }
                column(Employee_Disciplinary_Cases__Date_Taken_;"Date Taken")
                {
                }
                column(Employee_Disciplinary_Cases__Disciplinary_Remarks_;"Disciplinary Remarks")
                {
                }
                column(Employee_Disciplinary_Cases__Cases_Discusion_;"Cases Discusion")
                {
                }
                column(Reff__NoCaption;Reff__NoCaptionLbl)
                {
                }
                column(Employee_Disciplinary_Cases_DateCaption;FieldCaption(Date))
                {
                }
                column(Employee_Disciplinary_Cases__Disciplinary_Case_Caption;FieldCaption("Disciplinary Case"))
                {
                }
                column(Employee_Disciplinary_Cases__Recommended_Action_Caption;FieldCaption("Recommended Action"))
                {
                }
                column(Employee_Disciplinary_Cases__Case_Description_Caption;FieldCaption("Case Description"))
                {
                }
                column(Employee_Disciplinary_Cases__Accused_Defence_Caption;FieldCaption("Accused Defence"))
                {
                }
                column(Employee_Disciplinary_Cases__Action_Taken_Caption;FieldCaption("Action Taken"))
                {
                }
                column(Date_ReportedCaption;Date_ReportedCaptionLbl)
                {
                }
                column(Employee_Disciplinary_Cases__Disciplinary_Remarks_Caption;FieldCaption("Disciplinary Remarks"))
                {
                }
                column(Employee_Disciplinary_Cases__Cases_Discusion_Caption;FieldCaption("Cases Discusion"))
                {
                }
                column(Employee_Disciplinary_Cases_Employee_No;"Employee No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Names:="HRM-Employee C"."First Name" + ' ' + "HRM-Employee C"."Middle Name" + ' ' + "HRM-Employee C"."Last Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        Names: Text[250];
        Employee_Disciplinary_CasesCaptionLbl: label 'Employee Disciplinary Cases';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        Reff__NoCaptionLbl: label 'Reff. No';
        Date_ReportedCaptionLbl: label 'Date Reported';
}

