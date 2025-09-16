#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65208 "Course Class List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Course Class List.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code) order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000009; 1000000009)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone1;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompPage;CompanyInformation."Home Page")
            {
            }
            column(CompPin;CompanyInformation."Company P.I.N")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompRegNo;CompanyInformation."Registration No.")
            {
            }
            column(progName;"ACA-Programme".Description)
            {
            }
            column(faculty;"ACA-Programme".Faculty)
            {
            }
            column(Semester;sems)
            {
            }
            column(ProgCode;"ACA-Programme".Code)
            {
            }
            dataitem(UnknownTable61517;UnknownTable61517)
            {
                DataItemLink = "Programme Code"=field(Code);
                DataItemTableView = sorting(Code,"Programme Code","Stage Code","Entry No") order(ascending);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_1000000015; 1000000015)
                {
                }
                column(UnitDesc;"ACA-Units/Subjects".Desription)
                {
                }
                column(UnitCode;"ACA-Units/Subjects".Code)
                {
                }
                dataitem(UnknownTable61549;UnknownTable61549)
                {
                    DataItemLink = Programme=field("Programme Code"),Unit=field(Code);
                    DataItemTableView = sorting("Student No.",Unit) order(ascending) where(Reversed=filter(No));
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = Programme,Stage,Unit;
                    column(ReportForNavId_1000000000; 1000000000)
                    {
                    }
                    column(filters;filters)
                    {
                    }
                    column(GroupingConcortion;"ACA-Programme".Code+sems+"ACA-Units/Subjects".Code)
                    {
                    }
                    column(studNo;"ACA-Student Units"."Student No.")
                    {
                    }
                    column(StudName;StudName)
                    {
                    }
                    column(seq;seq)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        Clear(StudName);
                        if Customer.Get("ACA-Student Units"."Student No.") then
                        StudName:=Customer.Name;

                        seq:=seq+1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(seq);
                        "ACA-Student Units".SetFilter("ACA-Student Units".Semester,sems);
                        Clear(filters);
                        filters:=ACAUnitsSubjects.GetFilters;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SemFilter;sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    TableRelation = "ACA-Semester".Code;
                }
            }
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
        if CompanyInformation.Get() then
        //  CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
        Clear(Gtoto);
        Clear(seq);
        ACASemesters.Reset;
        ACASemesters.SetRange("Current Semester",true);
        if ACASemesters.Find('-') then begin
          sems:=ACASemesters.Code;
          end;
    end;

    trigger OnPreReport()
    begin

        if sems='' then Error('Specify a Semester');
    end;

    var
        CompanyInformation: Record "Company Information";
        Gtoto: Decimal;
        seq: Integer;
        StudName: Code[150];
        Customer: Record Customer;
        HRMEmployeeC: Record UnknownRecord61188;
        LectName: Text[220];
        progName: Code[150];
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        sems: Code[20];
        ACASemesters: Record UnknownRecord61692;
        filters: Text[1024];
}

