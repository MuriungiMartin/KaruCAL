#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1602 "Office Document Selection"
{
    Caption = 'Document Selection';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Office Document Selection";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type that the entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Lookup = true;
                    ToolTip = 'Specifies the number of the involved document.';
                }
                field(Series;Series)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the series of the involved document, such as Purchasing or Sales.';
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the involved document has been posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of the document.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("View Document")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'View Document';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'View the selected document.';

                trigger OnAction()
                var
                    TempOfficeAddinContext: Record "Office Add-in Context" temporary;
                    OfficeMgt: Codeunit "Office Management";
                    OfficeDocumentHandler: Codeunit "Office Document Handler";
                begin
                    OfficeMgt.GetContext(TempOfficeAddinContext);
                    OfficeDocumentHandler.OpenIndividualDocument(TempOfficeAddinContext,Rec);
                end;
            }
        }
    }
}

