#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68938 "ACA-Prog. Units Buffer"
{
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61749;
    SourceTableView = where(Posted=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Counted;Counted)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prog. Code";"Prog. Code")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Failure Reason";"Failure Reason")
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
            group(ActionGroup8)
            {
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Units';
                    Image = ImportCodes;
                    Promoted = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        if Confirm('Import Programme Units?',true)=false then Error('Cancelled by user..');
                        Xmlport.Run(50155,false,true);
                        Message('Units Imported into the Programme Units Successfully');
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Units';
                    Image = PostOrder;
                    Promoted = true;

                    trigger OnAction()
                    var
                        buff: Record UnknownRecord61749;
                        progUnits: Record UnknownRecord61517;
                    begin
                         if Confirm('Post units & Subjects?',true)=false then Error('Canceled by user..');
                         buff.Reset;
                         buff.SetRange(Posted,false);
                         if buff.Find('-') then begin
                         repeat
                          begin
                            progUnits.Reset;
                            progUnits.SetRange(progUnits.Code,buff."Unit Code");
                            progUnits.SetRange(progUnits."Programme Code",buff."Prog. Code");
                            progUnits.SetRange(progUnits."Stage Code",buff.Stage);
                            if not (progUnits.Find('-')) then begin
                            progUnits.Init;
                              progUnits.Code:=buff."Unit Code";
                              progUnits."Programme Code":=buff."Prog. Code";
                              progUnits."Stage Code":=buff.Stage;
                              progUnits.Desription:=buff.Description;
                              progUnits."Credit Hours":=buff."Credit Hours";
                              progUnits."No. Units":=buff."Credit Hours";
                              progUnits.Insert;
                              buff.Posted:=true;
                              buff.Modify;
                            end else begin
                              progUnits.Desription:=buff.Description;
                              progUnits."Credit Hours":=buff."Credit Hours";
                              progUnits."No. Units":=buff."Credit Hours";
                              progUnits.Modify;

                            end;
                            buff.Posted:=true;
                            buff.Modify;
                          end;
                         until buff.Next=0;
                         end;
                    end;
                }
            }
        }
    }
}

