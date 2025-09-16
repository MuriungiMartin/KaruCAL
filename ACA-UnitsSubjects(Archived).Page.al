#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56610 "ACA-Units/Subjects (Archived)"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61517;
    SourceTableView = where("Old Unit"=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Desription;Desription)
                {
                    ApplicationArea = Basic;
                }
                field("Medical Unit";"Medical Unit")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Type";"Unit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Old Unit";"Old Unit")
                {
                    ApplicationArea = Basic;
                }
                field("No. Units";"No. Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'CF';
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
                field("Default Exam Category";"Default Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Combination Count";"Combination Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Table";"Time Table")
                {
                    ApplicationArea = Basic;
                }
                field("Not Allocated";"Not Allocated")
                {
                    ApplicationArea = Basic;
                }
                field("Common Unit";"Common Unit")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Hours Per Week';
                }
                field(Prerequisite;Prerequisite)
                {
                    ApplicationArea = Basic;
                }
                field("Students Registered";"Students Registered")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Rest)
            {
                ApplicationArea = Basic;
                Caption = 'Restore Unit';
                Image = CalculateWhseAdjustment;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if not (UserSetup.Find('-')) then Error('Access denied!');
                    if UserSetup."Restore Archived Units"=false then Error('Access denied!');
                    if Confirm('Restore the unit: '+Rec.Code+','+Rec.Desription,false)=false then Error('Unit restoration cancelled!');
                    Rec."Old Unit":=false;
                    Rec.Modify;
                end;
            }
        }
    }

    var
        UnitsSubj: Record UnknownRecord61517;
        UserSetup: Record "User Setup";
}

