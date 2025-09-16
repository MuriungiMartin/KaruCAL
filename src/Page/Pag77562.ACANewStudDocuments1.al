#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77562 "ACA-New Stud. Documents 1"
{
    Caption = 'DoDocuments';
    DataCaptionFields = "Document Code";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable77360;

    layout
    {
        area(content)
        {
            field("Document Code";"Document Code")
            {
                ApplicationArea = Basic;
            }
            field(Document_Image;Document_Image)
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = Chart;
            }
            field("Approval Comments";"Approval Comments")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ApproveDocumentz)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(CurrDoc);
                    CurrDoc.Reset;
                    CurrDoc.SetRange("Academic Year",Rec."Academic Year");
                    CurrDoc.SetRange("Index Number",Rec."Index Number");
                    CurrDoc.SetRange("Document Code",Rec."Document Code");
                    if CurrDoc.Find('-') then begin
                      ApproveDocument(CurrDoc,UserId);
                      end;
                      CurrPage.Close;
                end;
            }
            action(RejectDocumentz)
            {
                ApplicationArea = Basic;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(CurrDoc);
                    CurrDoc.Reset;
                    CurrDoc.SetRange("Academic Year",Rec."Academic Year");
                    CurrDoc.SetRange("Index Number",Rec."Index Number");
                    CurrDoc.SetRange("Document Code",Rec."Document Code");
                    if CurrDoc.Find('-') then begin
                      RejectDocument(CurrDoc."Document Code",Rec."Academic Year",UserId,Rec."Index Number");
                      end;
                end;
            }
        }
    }

    var
        CurrDoc: Record UnknownRecord77360;
}

