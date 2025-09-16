#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51046 "Employee Next of kin Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Next of kin Report.rdlc';

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
            column(namez;namez)
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(Employee_Next_of_KinCaption;Employee_Next_of_KinCaptionLbl)
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
            column(HR_Employee_Kin_RelationshipCaption;"HRM-Employee Kin".FieldCaption(Relationship))
            {
            }
            column(Kin_NameCaption;Kin_NameCaptionLbl)
            {
            }
            column(HR_Employee_Kin__Office_Tel_No_Caption;"HRM-Employee Kin".FieldCaption("Office Tel No"))
            {
            }
            column(HR_Employee_Kin__Home_Tel_No_Caption;"HRM-Employee Kin".FieldCaption("Home Tel No"))
            {
            }
            dataitem(UnknownTable61323;UnknownTable61323)
            {
                DataItemLink = "Employee Code"=field("No.");
                column(ReportForNavId_9676; 9676)
                {
                }
                column(HR_Employee_Kin_Relationship;Relationship)
                {
                }
                column(HR_Employee_Kin__Office_Tel_No_;"Office Tel No")
                {
                }
                column(HR_Employee_Kin__Home_Tel_No_;"Home Tel No")
                {
                }
                column(KinNames;KinNames)
                {
                }
                column(HR_Employee_Kin_Employee_Code;"Employee Code")
                {
                }
                column(HR_Employee_Kin_SurName;SurName)
                {
                }
                column(HR_Employee_Kin_Other_Names;"Other Names")
                {
                }
                column(IDNoPassportNo_HREmployeeKin;"HRM-Employee Kin"."ID No/Passport No")
                {
                }
                column(DateOfBirth_HREmployeeKin;"HRM-Employee Kin"."Date Of Birth")
                {
                }

                trigger OnAfterGetRecord()
                begin

                      Clear(KinNames);
                      KinNames:="HRM-Employee Kin".SurName+''+"HRM-Employee Kin"."Other Names";
                end;
            }

            trigger OnAfterGetRecord()
            begin

                  Clear(namez);
                  namez:="HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name";
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
        namez: Code[250];
        KinNames: Code[250];
        Employee_Next_of_KinCaptionLbl: label 'Employee Next of Kin';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        Kin_NameCaptionLbl: label 'Kin Name';
}

