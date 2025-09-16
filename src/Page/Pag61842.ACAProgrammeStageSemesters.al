#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 61842 "ACA-Programme Stage Semesters"
{
    PageType = List;
    SourceTable = UnknownTable61842;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                }
                field(Start;Start)
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Units Registration Deadline";"Units Registration Deadline")
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
            action(GetSems)
            {
                ApplicationArea = Basic;
                Caption = 'Get Semesters';
                Image = GetActionMessages;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Get Semesters?',false)=false then Error('Cancelled by user!');
                    if Confirm('Update all stage Semesters for '+Rec."Programme Code"+'?',false)=false then begin
                    ACAProgrammeStageSemesters.Reset;
                    ACAProgrammeStageSemesters.SetRange("Programme Code",Rec.GetFilter("Programme Code"));
                    ACAProgrammeStageSemesters.SetRange(Stage,Rec.GetFilter(Stage));
                    if ACAProgrammeStageSemesters.Find('-') then ACAProgrammeStageSemesters.DeleteAll;

                    ACASemesters.Reset;
                    if ACASemesters.Find('-') then begin
                      repeat
                        begin
                        ACAProgrammeStageSemesters.Init;
                        ACAProgrammeStageSemesters."Programme Code":=Rec.GetFilter("Programme Code");
                        ACAProgrammeStageSemesters.Semester:=ACASemesters.Code;
                        ACAProgrammeStageSemesters.Stage:=Rec.GetFilter(Stage);
                        ACAProgrammeStageSemesters.Current:=ACASemesters."Current Semester";
                        ACAProgrammeStageSemesters.Remarks:=ACASemesters.Remarks;
                        ACAProgrammeStageSemesters.Start:=ACASemesters.From;
                        ACAProgrammeStageSemesters."End Date":=ACASemesters."To";
                        ACAProgrammeStageSemesters."Units Registration Deadline":=ACASemesters."Registration Deadline";
                        ACAProgrammeStageSemesters.Insert(true);
                        end;
                        until ACASemesters.Next=0;
                      end;
                      end else begin
                        ACAProgrammeStages.Reset;
                        ACAProgrammeStages.SetRange("Programme Code",Rec.GetFilter("Programme Code"));
                        if ACAProgrammeStages.Find('-') then begin
                            repeat
                                begin
                                  ////////////////////////////////////////////////////
                    ACAProgrammeStageSemesters.Reset;
                    ACAProgrammeStageSemesters.SetRange("Programme Code",Rec.GetFilter("Programme Code"));
                    ACAProgrammeStageSemesters.SetRange(Stage,ACAProgrammeStages.Code);
                    if ACAProgrammeStageSemesters.Find('-') then ACAProgrammeStageSemesters.DeleteAll;

                    ACASemesters.Reset;
                    if ACASemesters.Find('-') then begin
                      repeat
                        begin
                        ACAProgrammeStageSemesters.Init;
                        ACAProgrammeStageSemesters."Programme Code":=ACAProgrammeStages."Programme Code";
                        ACAProgrammeStageSemesters.Semester:=ACASemesters.Code;
                        ACAProgrammeStageSemesters.Stage:=ACAProgrammeStages.Code;
                        ACAProgrammeStageSemesters.Current:=ACASemesters."Current Semester";
                        ACAProgrammeStageSemesters.Start:=ACASemesters.From;
                        ACAProgrammeStageSemesters."End Date":=ACASemesters."To";
                        ACAProgrammeStageSemesters."Units Registration Deadline":=ACASemesters."Registration Deadline";
                        ACAProgrammeStageSemesters.Remarks:=ACASemesters.Remarks;
                        ACAProgrammeStageSemesters.Insert(true);
                        end;
                        until ACASemesters.Next=0;
                      end;
                                  ////////////////////////////////////////////////////
                                end;
                              until ACAProgrammeStages.Next=0;
                          end;
                        end;
                end;
            }
        }
    }

    var
        ACASemesters: Record UnknownRecord61692;
        ACAProgrammeStageSemesters: Record UnknownRecord61842;
        ACAProgrammeStages: Record UnknownRecord61516;
}

