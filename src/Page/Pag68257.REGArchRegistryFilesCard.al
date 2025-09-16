#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68257 "REG-Arch.Registry Files Card"
{
    Editable = false;
    PageType = Document;
    SourceTable = UnknownTable61634;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("File No.";"File No.")
                {
                    ApplicationArea = Basic;
                }
                field("File Subject/Description";"File Subject/Description")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("File Type";"File Type")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Allowable Files";"Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Issue";"Date of Issue")
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Officer";"Issuing Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Circulation Reason";"Circulation Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Return Date";"Expected Return Date")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Officer";"Receiving Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Delivery Officer";"Delivery Officer")
                {
                    ApplicationArea = Basic;
                }
                field("File Status";"File Status")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatch Status";"Dispatch Status")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18;Notes)
            {
            }
            systempart(Control19;MyNotes)
            {
            }
            systempart(Control20;Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(active)
            {
                ApplicationArea = Basic;
                Caption = 'Set as Active';
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                           if (Confirm('Mark as Active?',true)=false) then Error('Cancelled!');
                           "File Status":="file status"::Active;
                           Modify;
                           Message('File set as Active!')
                end;
            }
            action(Bring_up)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Bring-up';
                Image = History;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Mark as Bring-Up?',false)=false then exit;

                                                   "File Status":="file status"::Bring_up;
                                                   Modify;
                                                   Message('Set as Bring-up!');
                end;
            }
            action(part_act)
            {
                ApplicationArea = Basic;
                Caption = 'Partially Active';
                Image = AdjustItemCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Set As Partially Active?',false)=false then exit;

                                                   "File Status":="file status"::"Partially Active";
                                                   Modify;
                                                   Message('File set as Partially Active');
                end;
            }
        }
    }
}

