#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68743 "ACA-Units/Subjects"
{
    DeleteAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61517;
    SourceTableView = where("Old Unit"=filter(No));

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
                field("Exempt CAT";"Exempt CAT")
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
                    Editable = true;
                }
                field("No. Units";"No. Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Units';
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
                field("Default Exam Category";"Default Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Combination Count";"Combination Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Exempt From Evaluation";"Exempt From Evaluation")
                {
                    ApplicationArea = Basic;
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
                    Caption = 'credit Hours';
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
                field("Ignore in Final Average";"Ignore in Final Average")
                {
                    ApplicationArea = Basic;
                }
                field(Is_Cat_Only;Is_Cat_Only)
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
            action("Save New Units")
            {
                ApplicationArea = Basic;
                Caption = 'Save New Units';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                       UnitsSubj.Reset;
                       UnitsSubj.SetFilter(UnitsSubj."New Unit",'%1',true);
                       if UnitsSubj.Find('-') then begin
                       repeat
                       UnitsSubj."New Unit":=false;
                       UnitsSubj.Modify;
                       until UnitsSubj.Next=0;
                       end;
                end;
            }
            group(Unit)
            {
                Caption = 'Unit';
                action("Fees Structure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fees Structure';
                    RunObject = Page "ACA-Fees By Unit";
                    RunPageLink = "Programme Code"=field("Programme Code"),
                                  "Stage Code"=field("Stage Code"),
                                  "Unit Code"=field(Code);
                }
            }
            group("Multiple Combination")
            {
                Caption = 'Multiple Combination';
                action("Multiple Option Combination")
                {
                    ApplicationArea = Basic;
                    Caption = 'Multiple Option Combination';
                    RunObject = Page "ACA-Units Option Combination";
                    RunPageLink = Programme=field("Programme Code"),
                                  Stage=field("Stage Code"),
                                  Unit=field(Code);
                }
            }
        }
    }

    var
        UnitsSubj: Record UnknownRecord61517;
}

