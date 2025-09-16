#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66682 "Aca-Repeated Units"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61517;
    SourceTableView = where(Repeatitions=filter(>1),
                            "Stage Code"=filter(<>""),
                            Code=filter(<>""));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Stage Code";"Stage Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Desription;Desription)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Merge to Stage";"Merge to Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Repeatitions;Repeatitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Repeats';
                    Editable = false;
                    Enabled = false;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Total Credit Hours";"Total Credit Hours")
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
            action(MergeUnits)
            {
                ApplicationArea = Basic;
                Caption = 'Merge Units';
                Image = Migration;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Merge to Stage");
                    ACAUnitsSubjects.Reset;
                    ACAUnitsSubjects.SetRange("Programme Code", xRec."Programme Code");
                    ACAUnitsSubjects.SetFilter("Stage Code",'%1','');
                    if ACAUnitsSubjects.Find('-') then ACAUnitsSubjects.DeleteAll;
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if not UserSetup.Find('-') then Error('Access denied!');
                    if not UserSetup."Can Edit/Merge Units" then Error('Access denied!');
                    if Confirm('Merge Units to: '+Rec."Merge to Stage"+'?',true)=false then Error('Cancelled by user!');
                    if Rec."Stage Code" = '' then Error('You can not merge units onto an empty stage');
                    Clear(StageToMaintain);
                    Clear(RecsToDelete);
                    StageToMaintain:=Rec."Merge to Stage";

                    ACAUnitsSubjects.Reset;
                    ACAUnitsSubjects.SetRange("Programme Code", Rec."Programme Code");
                    ACAUnitsSubjects.SetFilter("Stage Code",'<>%1','');
                    ACAUnitsSubjects.SetFilter(Code,Rec.Code);
                    ACAUnitsSubjects.SetFilter("Stage Code",'%1',StageToMaintain);
                    if ACAUnitsSubjects.Find('-') then if ACAUnitsSubjects.Count>1 then begin
                      repeat
                          begin
                      RecsToDelete:=RecsToDelete+1;
                      if RecsToDelete>1 then ACAUnitsSubjects.Delete;
                          end;
                        until ACAUnitsSubjects.Next=0;
                      end;
                    ACAUnitsSubjects.Reset;
                    ACAUnitsSubjects.SetRange("Programme Code", Rec."Programme Code");
                    ACAUnitsSubjects.SetFilter("Stage Code",'<>%1','');
                    ACAUnitsSubjects.SetFilter(Code,Rec.Code);
                    if ACAUnitsSubjects.Find('-') then if ACAUnitsSubjects.Count>1 then begin
                    Rec.Delete;
                      end;

                    ACAUnitsSubjects.Reset;
                    ACAUnitsSubjects.SetRange("Programme Code", xRec."Programme Code");
                    ACAUnitsSubjects.SetFilter("Stage Code",'<>%1','');
                    ACAUnitsSubjects.SetFilter(Code,Rec.Code);
                    ACAUnitsSubjects.SetFilter("Stage Code",'<>%1',StageToMaintain);
                    if ACAUnitsSubjects.Find('-') then begin
                        repeat
                            begin
                         ACAUnitsSubjects2.Reset;
                         ACAUnitsSubjects2.SetRange("Programme Code",xRec."Programme Code");
                         ACAUnitsSubjects2.SetRange(Code,ACAUnitsSubjects.Code);
                         if ACAUnitsSubjects2.Find('-') then if ACAUnitsSubjects2.Count > 1 then begin
                            ACAUnitsSubjects2.Rename(ACAUnitsSubjects2.Code,ACAUnitsSubjects2."Programme Code",StageToMaintain,ACAUnitsSubjects2."Entry No");
                           ACAUnitsSubjects2.Delete;
                           end else begin
                            ACAUnitsSubjects2.Rename(ACAUnitsSubjects2.Code,ACAUnitsSubjects2."Programme Code",StageToMaintain,ACAUnitsSubjects2."Entry No");
                             end;


                            end;
                          until ACAUnitsSubjects.Next=0;
                      end;
                      Message('Units Merged successfully!');

                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        ACAUnitsSubjects3: Record UnknownRecord61517;
        StageToMaintain: Code[20];
        SubjectEntryNo: Code[10];
        RecsToDelete: Integer;
}

