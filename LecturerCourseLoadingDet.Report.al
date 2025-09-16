#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69274 "Lecturer Course Loading Det."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Course Loading Det..rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code) order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompPhones;CompanyInformation."Phone No."+'\'+CompanyInformation."Phone No. 2")
            {
            }
            column(CompMails;CompanyInformation."Home Page"+'\'+CompanyInformation."E-Mail")
            {
            }
            column(CompAddresses;CompanyInformation.Address+'\'+CompanyInformation."Address 2"+' - '+CompanyInformation.City)
            {
            }
            column(ProgCode;"ACA-Programme".Code)
            {
            }
            column(ProgDescription;"ACA-Programme".Description)
            {
            }
            column(fliters;filters)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                DataItemTableView = sorting("Programme Code",Code) order(ascending);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_1000000060; 1000000060)
                {
                }
                column(StagesCode;"ACA-Programme Stages".Code)
                {
                }
                column(StageDescription;"ACA-Programme Stages".Description)
                {
                }
                column(fliters2;filters2)
                {
                }
                dataitem(UnknownTable65202;UnknownTable65202)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code);
                    RequestFilterFields = Programme,Stage,Semester;
                    column(ReportForNavId_1000000032; 1000000032)
                    {
                    }
                    column(EmpNames;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
                    {
                    }
                    column(Salutations;Format(HRMEmployeeC.Title))
                    {
                    }
                    column(SemesterDesc;ACASemester.Description)
                    {
                    }
                    column(Lname;HRMEmployeeC."Last Name")
                    {
                    }
                    column(fName;HRMEmployeeC."First Name")
                    {
                    }
                    column(MName;HRMEmployeeC."Middle Name")
                    {
                    }
                    column(UnitStage;"ACA-Lecturers Units".Stage)
                    {
                    }
                    column(UnitProg;"ACA-Lecturers Units".Programme)
                    {
                    }
                    column(UnitCode;"ACA-Lecturers Units".Unit)
                    {
                    }
                    column(Lect;"ACA-Lecturers Units".Lecturer)
                    {
                    }
                    column(UnitDesc;"ACA-Lecturers Units".Description)
                    {
                    }
                    column(UnitCost;"ACA-Lecturers Units"."Unit Cost")
                    {
                    }
                    column(MarksSubmitted;"ACA-Lecturers Units"."Marks Submitted")
                    {
                    }
                    column(AngagementTerms;"ACA-Lecturers Units"."Engagement Terms")
                    {
                    }
                    column(ExamsSubmitted;"ACA-Lecturers Units"."Exams Submitted")
                    {
                    }
                    column(CatsSubmitted;"ACA-Lecturers Units"."CATs Submitted")
                    {
                    }
                    column(Approved;"ACA-Lecturers Units".Approved)
                    {
                    }
                    column(seq;seq)
                    {
                    }
                    column(fliters3;filters3)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        HRMEmployeeC.Reset;
                        HRMEmployeeC.SetRange("No.","ACA-Lecturers Units".Lecturer);
                        if HRMEmployeeC.Find('-') then begin
                          end;
                        ACASemester.Reset;
                        ACASemester.SetRange(Code,"ACA-Lecturers Units".Semester);
                        if ACASemester.Find('-') then
                          ACASemester.Validate(ACASemester.Description);
                        seq:=seq+1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(filters3);
                        filters3:="ACA-Lecturers Units".GetFilters;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(seq);
                end;

                trigger OnPreDataItem()
                begin
                    Clear(filters2);
                    filters2:="ACA-Programme Stages".GetFilters;
                end;
            }

            trigger OnPreDataItem()
            begin
                Clear(filters);
                filters:="ACA-Programme".GetFilters;
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
        HRMEmployeeC: Record UnknownRecord61188;
        ACASemester: Record UnknownRecord61692;
        seq: Integer;
        LectLoadBatchLines: Record UnknownRecord65201;
        "Lect Load Batch Lines": Record UnknownRecord65201;
        filters: Text[1024];
        filters2: Text[1024];
        filters3: Text[1024];
}

