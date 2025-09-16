#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68129 "ACA-Auto_Time Table"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable61571;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Max Hours Continiously";"Max Hours Continiously")
                {
                    ApplicationArea = Basic;
                }
                field("Max Hours Weekly";"Max Hours Weekly")
                {
                    ApplicationArea = Basic;
                }
                field("Max Days Per Week";"Max Days Per Week")
                {
                    ApplicationArea = Basic;
                }
                field("Max Lecturer Hours Daily";"Max Lecturer Hours Daily")
                {
                    ApplicationArea = Basic;
                }
                field("Max Lecturer Days Per Week";"Max Lecturer Days Per Week")
                {
                    ApplicationArea = Basic;
                }
                field("Max Class Capacity";"Max Class Capacity")
                {
                    ApplicationArea = Basic;
                }
                field("Max Class Weekly";"Max Class Weekly")
                {
                    ApplicationArea = Basic;
                }
                field(Released;Released)
                {
                    ApplicationArea = Basic;
                }
                field("Released By";"Released By")
                {
                    ApplicationArea = Basic;
                }
                field("Released On";"Released On")
                {
                    ApplicationArea = Basic;
                }
                field("Last Opened By";"Last Opened By")
                {
                    ApplicationArea = Basic;
                }
                field("Last Opened On";"Last Opened On")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Generate Teaching Time Table")
            {
                ApplicationArea = Basic;
                Image = "Action";

                trigger OnAction()
                begin

                     TestField(Released,false);
                     TTRandom.GenerateClass(Semester,"Max Class Capacity");
                     TTRandom.GenerateTT("Max Class Weekly",Semester);
                     Message('Done');
                end;
            }
            separator(Action1102755011)
            {
            }
            action("Generate Exams Time Table")
            {
                ApplicationArea = Basic;
            }
            separator(Action16)
            {
            }
            action("Clear Time Table")
            {
                ApplicationArea = Basic;
                Image = ClearLog;

                trigger OnAction()
                begin

                      TestField(Released,false);
                      TTRandom.ClearCurrentTimeTable(Semester,Campus);
                end;
            }
            separator(Action18)
            {
            }
            action(Release)
            {
                ApplicationArea = Basic;
            }
            separator(Action20)
            {
            }
            action("Re Open")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin

                         TestField(Released,true);
                         if Confirm('Do you really want to re-open the time table?')=true then begin
                         TT.Reset;
                         TT.SetRange(TT.Semester,Semester);
                         TT.SetRange(TT."Campus Code",Campus);
                         if TT.Find('-') then begin
                         repeat
                         TT.Released:=false;
                         TT.Modify;
                         until TT.Next=0;
                         end;
                         Released:=false;
                         "Last Opened By":=UserId;
                         "Last Opened On":=Today;
                         Modify;

                         end;
                end;
            }
            separator(Action22)
            {
            }
            action("Set Active Stages")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                     Report.Run(39006202,true,true);
                end;
            }
        }
    }

    var
        TTRandom: Codeunit "Student Finance Handler";
        TT: Record UnknownRecord61540;
}

