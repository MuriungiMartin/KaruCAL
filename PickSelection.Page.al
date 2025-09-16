#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7343 "Pick Selection"
{
    Caption = 'Pick Selection';
    DataCaptionFields = "Document Type","Location Code";
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Pick Request";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document from which the pick originated.';
                }
                field("Document Subtype";"Document Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the type of document that the component pick request is related to, such as Released and Assembly.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document for which the program has received a pick request.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the request is occurring.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the code of the shipment method to be used.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the shipping agent code information on the warehouse document header.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the shipping agent service code that the program copies from the warehouse document header.';
                }
                field(AssembleToOrder;GetAsmToOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Assemble to Order';
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }


    procedure GetResult(var WhsePickRqst: Record "Whse. Pick Request")
    begin
        CurrPage.SetSelectionFilter(WhsePickRqst);
    end;

    local procedure GetAsmToOrder(): Boolean
    var
        AsmHeader: Record "Assembly Header";
    begin
        if "Document Type" = "document type"::Assembly then begin
          AsmHeader.Get("Document Subtype","Document No.");
          AsmHeader.CalcFields("Assemble to Order");
          exit(AsmHeader."Assemble to Order");
        end;
    end;
}

