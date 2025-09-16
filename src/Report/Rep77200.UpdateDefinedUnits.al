#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77200 "Update Defined Units"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(progcz;UnknownTable61511)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(AcadYear;UnknownTable61382)
            {
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(ACAAcademicYear);
                    ACAAcademicYear.Reset;
                    ACAAcademicYear.SetRange(Code,'<>%1',AcadYear.Code);
                    if ACAAcademicYear.Find('+') then begin
                      repeat
                        begin
                          AcaAcdaYearProgrammes.Init;
                          AcaAcdaYearProgrammes."Programme Code"  := progcz.Code;
                          AcaAcdaYearProgrammes."Academic Year" := AcadYear.Code;
                          if AcaAcdaYearProgrammes.Insert then;
                    Clear(ACADefinedUnitsperYoS2);
                    ACADefinedUnitsperYoS2.Reset;
                    ACADefinedUnitsperYoS2.SetRange(Programme,progcz.Code);
                    ACADefinedUnitsperYoS2.SetFilter("Academic Year",'=%1',ACAAcademicYear.Code);
                    if ACADefinedUnitsperYoS2.Find('-') then  begin
                      repeat
                        begin
                        ACADefinedUnitsperYoS.Init;
                        ACADefinedUnitsperYoS.Programme :=progcz.Code;
                        ACADefinedUnitsperYoS."Year of Study" :=ACADefinedUnitsperYoS2."Year of Study";
                        ACADefinedUnitsperYoS.Options :=ACADefinedUnitsperYoS.Options;
                        ACADefinedUnitsperYoS."Academic Year" :=AcadYear.Code;
                        ACADefinedUnitsperYoS."Number of Units" :=ACADefinedUnitsperYoS2."Number of Units";
                       if ACADefinedUnitsperYoS.Insert then;
                        end;
                          until ACADefinedUnitsperYoS2.Next = 0;
                      end;
                        end;
                        until ACAAcademicYear.Next = 0;
                      end;
                end;
            }
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
        ACAAcademicYear: Record UnknownRecord61382;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ACADefinedUnitsperYoS2: Record UnknownRecord78017;
        AcaAcdaYearProgrammes: Record "Aca-Acda. Year Programmes";
}

