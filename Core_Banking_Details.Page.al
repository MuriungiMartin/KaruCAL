#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77384 Core_Banking_Details
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Core_Banking_Details;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected;Selected)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Number";"Transaction Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transaction Description";"Transaction Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transaction Occurences";"Transaction Occurences")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Posting Status";"Posting Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Core_Banking Status";"Core_Banking Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Trans. Amount";"Trans. Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Exists in Customer";"Exists in Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student Exists';
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostInd)
            {
                ApplicationArea = Basic;
                Caption = 'Post Selected';
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Post selected receipt for '+Rec."Student No."+', Receipt: '+Rec."Transaction Number"+'?',true) = false then Error('Cancelled!');
                    Rec.Validate(Posted,true);
                    if Rec.Posted = true then begin
                         Rec.CalcFields("Exists in Customer");
                         if Rec."Exists in Customer" = false then begin
                           Rec.Posted := false;
                           end;
                        if Rec.Modify then;
                      end;
                      Message('Receipt posted!');
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive Receipt';
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Delete receipt?',false) = false then Error('Cancelled!');
                    Rec.Delete(true);
                    Message('Deleted!');
                end;
            }
        }
    }

    var
        CoreBankingDetailsz: Record Core_Banking_Details;
        Core_Banking_DetailsArchive: Record UnknownRecord77390;
}

