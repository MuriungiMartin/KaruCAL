#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68931 "REG-Active Files Card"
{
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
                    Editable = false;
                }
                field("File Subject/Description";"File Subject/Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("File Type";"File Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Maximum Allowable Files";"Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Issue";"Date of Issue")
                {
                    ApplicationArea = Basic;
                }
                field("File Status";"File Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requisition No";"Requisition No")
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
                field("Receiving Office";"Receiving Office")
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
        area(processing)
        {
            action(Bringup)
            {
                ApplicationArea = Basic;
                Caption = 'Set as Bring-up';
                Image = History;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                           if (Confirm('Mark as Bring-up?',true)=false) then Error('Cancelled!');
                           "File Status":="file status"::Bring_up;
                           Modify;
                           Message('File set as Bring-up!')
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive File';
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Archive File?',false)=false then exit;

                                                   "File Status":="file status"::Archived;
                                                   Modify;
                                                   Message('File archived!');
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
            separator(Action24)
            {
            }
            action("Dispatch ")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch File';
                Image = Delivery;
                Promoted = true;

                trigger OnAction()
                begin
                           if (Confirm('Dispatch File?',true)=false) then Error('Cancelled!');
                           "Dispatch Status":="dispatch status"::Dispatched;
                           Modify;
                           Message('File Dispatched!')
                end;
            }
        }
    }
}

