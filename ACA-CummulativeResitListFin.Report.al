#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78053 "ACA-Cummulative Resit List Fin"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Cummulative Resit List Fin.rdlc';

    dataset
    {
        dataitem(ExamCoregcs;UnknownTable66651)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Academic Year","School Code","Year of Study";
            column(ReportForNavId_1; 1)
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompMail;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(CompAddress;CompanyInformation.Address+','+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Prog;ExamCoregcs.Programme)
            {
            }
            column(YoS;ExamCoregcs."Year of Study")
            {
            }
            column(AcadYear;ExamCoregcs."Academic Year")
            {
            }
            column(SchCode;ExamCoregcs."School Code")
            {
            }
            column(StudentNo;ExamCoregcs."Student Number")
            {
            }
            column(StudName;ExamCoregcs."Student Name")
            {
            }
            column(SchName;ExamCoregcs."School Name")
            {
            }
            column(Class;ExamCoregcs.Classification)
            {
            }
            column(ProgName;ExamCoregcs."Programme Name")
            {
            }
            column(Filters;Filters)
            {
            }
            dataitem(CummResits;UnknownTable66657)
            {
                DataItemLink = "Student Number"=field("Student Number"),"Academic Year"=field("Academic Year");
                column(ReportForNavId_2; 2)
                {
                }
                column(UnitCode;CummResits."Unit Code")
                {
                }
                column(UnitDesc;CummResits."Unit Description")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                Clear(Filters);
                Filters:=ExamCoregcs.GetFilters;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        Filters: Text[1024];
}

