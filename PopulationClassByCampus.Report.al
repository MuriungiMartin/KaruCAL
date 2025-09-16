#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51776 "Population Class By Campus"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Population Class By Campus.rdlc';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = where("Dimension Code"=filter('CAMPUS'));
            column(ReportForNavId_1; 1)
            {
            }
            column(DimName;Name)
            {
            }
            column(CampTotalNew;CampTotalNew)
            {
            }
            column(CampTotalContinuing;CampTotalContinuing)
            {
            }
            column(CampTotal;CampTotal)
            {
            }
            column(GrandTotalNew;GrandTotalNew)
            {
            }
            column(GrandTotalCont;GrandTotalCont)
            {
            }
            column(GrandTotal;GrandTotal)
            {
            }
            dataitem(UnknownTable61568;UnknownTable61568)
            {
                DataItemTableView = sorting(Series,Code) order(ascending);
                column(ReportForNavId_2; 2)
                {
                }
                column(Title1;'STUDENT POPULATION PER CAMPUS & CATEGORY AS AT '+Format(Today,0,4)+ ', '+Sems)
                {
                }
                column(ExamCode;Code)
                {
                }
                column(CATNew;CATNew1)
                {
                }
                column(CATContinuing;CATContinuing1)
                {
                }
                column(CATTotal;CATTotal1)
                {
                }
                column(pic;info.Picture)
                {
                }

                trigger OnAfterGetRecord()
                begin

                        Clear(CATTotal1);
                        Clear(CATContinuing1);
                        Clear(CATNew1);
                        Clear(CATTotal);
                        Clear(CATContinuing);
                        Clear(CATNew);

                       courseReg.Reset;
                       courseReg.SetRange(courseReg.Semester,Sems);
                       //courseReg.SETRANGE(courseReg."Academic Year",acadyear);
                       courseReg.SetRange(courseReg."Campus Code","Dimension Value".Code);
                       courseReg.SetRange(courseReg."Programme Exam Category","ACA-Exam Category".Code);
                       courseReg.SetRange(courseReg.Stage,'Y1S1');
                       if courseReg.Find('-') then begin
                        CATNew1:=courseReg.Count;
                        CampTotal1:=CampTotal1+(courseReg.Count);
                        GrandTotal1:=GrandTotal1+(courseReg.Count);
                        GrandTotalNew1:=GrandTotalNew1+(courseReg.Count);
                        CampTotalNew1:=CampTotalNew1+(courseReg.Count);
                       end;

                    // Pick Continuing Students
                        courseReg.Reset;
                       courseReg.SetRange(courseReg.Semester,Sems);
                       //courseReg.SETRANGE(courseReg."Academic Year",acadyear);
                       courseReg.SetRange(courseReg."Campus Code","Dimension Value".Code);
                       courseReg.SetRange(courseReg."Programme Exam Category","ACA-Exam Category".Code);
                       courseReg.SetFilter(courseReg.Stage,'<>Y1S1');
                       if courseReg.Find('-') then begin
                       CATContinuing1:=courseReg.Count;
                        CampTotal1:=CampTotal1+(courseReg.Count);
                        GrandTotal1:=GrandTotal1+(courseReg.Count);
                        GrandTotalCont1:=GrandTotalCont1+(courseReg.Count);;
                        CampTotalContinuing1:=CampTotalContinuing1+(courseReg.Count);
                       end;

                        CATTotal1:=CATNew1+CATContinuing1;


                    if CampTotal1<>0 then CampTotal:=Format(CampTotal1);
                    if CampTotalNew1<>0 then CampTotalNew:=Format(CampTotalNew1);
                    if CampTotalContinuing1<>0 then CampTotalContinuing:=Format(CampTotalContinuing1);
                    if GrandTotalNew1<>0 then GrandTotalNew:=Format(GrandTotalNew1);
                    if GrandTotalCont1<>0 then GrandTotalCont:=Format(GrandTotalCont1);
                    if GrandTotal1<>0 then GrandTotal:=Format(GrandTotal1);
                    if CATTotal1<>0 then CATTotal:=Format(CATTotal1);
                    if CATContinuing1<>0 then CATContinuing:=Format(CATContinuing1);
                    if CATNew1<>0 then CATNew:=Format(CATNew1);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                    Clear(CampTotal1);
                    Clear(CampTotalNew1);
                    Clear(CampTotalContinuing1);
                    Clear(CampTotal);
                    Clear(CampTotalNew);
                    Clear(CampTotalContinuing);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Semz;Sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester:';
                    TableRelation = "ACA-Semesters".Code;
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
            if info.Get() then Sems:=info."Last Semester Filter";
    end;

    trigger OnPreReport()
    begin

           info.Reset;
           if info.Find('-') then info.CalcFields(Picture);
           Clear(GrandTotalNew1);
           Clear(GrandTotalCont1);
           Clear(GrandTotal1);
           Clear(GrandTotalNew);
           Clear(GrandTotalCont);
           Clear(GrandTotal);


        if ((Sems<>'')) then acayrNsem:='Semester:  '+Sems
        else acayrNsem:='';


         info.Reset;
         if info.Find('-') then begin
         info.CalcFields(Picture);
         end;
    end;

    var
        info: Record "Company Information";
        acadyear: Code[20];
        Sems: Code[20];
        courseReg: Record UnknownRecord61532;
        acayrNsem: Code[50];
        CampTotal1: Integer;
        CampTotalNew1: Integer;
        CampTotalContinuing1: Integer;
        GrandTotalNew1: Integer;
        GrandTotalCont1: Integer;
        GrandTotal1: Integer;
        CATTotal1: Integer;
        CATContinuing1: Integer;
        CATNew1: Integer;
        CampTotal: Code[10];
        CampTotalNew: Code[10];
        CampTotalContinuing: Code[10];
        GrandTotalNew: Code[10];
        GrandTotalCont: Code[10];
        GrandTotal: Code[10];
        CATTotal: Code[10];
        CATContinuing: Code[10];
        CATNew: Code[10];
}

