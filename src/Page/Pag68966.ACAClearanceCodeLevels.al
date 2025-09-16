#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68966 "ACA-Clearance Code Levels"
{
    Caption = 'Clearance Code Levels';
    PageType = List;
    SourceTable = UnknownTable61754;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Clearance Level Code";"Clearance Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Standard;Standard)
                {
                    ApplicationArea = Basic;
                }
                field("Priority Level";"Priority Level")
                {
                    ApplicationArea = Basic;
                }
                field(Caption;Caption)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Title";"Approval Title")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Statement";"Approval Statement")
                {
                    ApplicationArea = Basic;
                }
                field("Get Property Summary";"Get Property Summary")
                {
                    ApplicationArea = Basic;
                }
                field("Include in Summary";"Include in Summary")
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
            action("Clearance Templates")
            {
                ApplicationArea = Basic;
                Caption = 'Clearance Templates';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                        if Standard then Error('Standard should not be true on Clearance levels.');
                    templates.Reset;
                    templates.SetRange(templates."Clearance Level Code","Clearance Level Code");
                    if templates.Find('-') then begin
                    end;

                    Page.Run(68967,templates);
                end;
            }
            action("Standard Clearance Approvers")
            {
                ApplicationArea = Basic;
                Caption = 'Standard Clearance Approvers';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                        if not Standard then Error('This applies to standard Clearance approvals only.');
                    stdClearance.Reset;
                    stdClearance.SetRange(stdClearance."Clearance Level Code","Clearance Level Code");
                    if stdClearance.Find('-') then begin
                    end;

                    Page.Run(68969,stdClearance);
                end;
            }
            action("Clearance Conditions")
            {
                ApplicationArea = Basic;
                Caption = 'Clearance Conditions';
                Image = Components;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    clconditions.Reset;
                    clconditions.SetRange(clconditions."Clearance Level Code","Clearance Level Code");
                    if clconditions.Find('-') then begin

                    end;// else error('No Level selected!');
                     Page.Run(69072,clconditions);
                end;
            }
        }
    }

    var
        stdClearance: Record UnknownRecord61757;
        templates: Record UnknownRecord61755;
        clconditions: Record UnknownRecord61759;
}

