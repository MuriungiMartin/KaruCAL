#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5774 "Warehouse Activity List"
{
    Caption = 'Warehouse Activity List';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Activity Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse header.';
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document to which the line relates, including sales order, purchase order, or transfer order.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the activity originated.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of activity, such as Put-away, that the warehouse performs on the lines that are attached to the header.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the warehouse activity takes place.';
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity.';
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number or the code of the customer or vendor that the line is linked to.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the external document number for the source document to which the warehouse activity is related.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                    Visible = false;
                }
                field("No. of Lines";"No. of Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of lines in the warehouse activity document.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.';
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case Type of
                          Type::"Put-away":
                            Page.Run(Page::"Warehouse Put-away",Rec);
                          Type::Pick:
                            Page.Run(Page::"Warehouse Pick",Rec);
                          Type::Movement:
                            Page.Run(Page::"Warehouse Movement",Rec);
                          Type::"Invt. Put-away":
                            Page.Run(Page::"Inventory Put-away",Rec);
                          Type::"Invt. Pick":
                            Page.Run(Page::"Inventory Pick",Rec);
                          Type::"Invt. Movement":
                            Page.Run(Page::"Inventory Movement",Rec);
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Put-away List")
            {
                ApplicationArea = Basic;
                Caption = 'Put-away List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Put-away List";
            }
            action("Picking List")
            {
                ApplicationArea = Basic;
                Caption = 'Picking List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Picking List";
            }
            action("Warehouse Movement List")
            {
                ApplicationArea = Basic;
                Caption = 'Warehouse Movement List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Movement List";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Caption := FormCaption;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirstAllowedRec(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(FindNextAllowedRec(Steps));
    end;

    trigger OnOpenPage()
    begin
        ErrorIfUserIsNotWhseEmployee;
    end;

    var
        Text000: label 'Warehouse Put-away List';
        Text001: label 'Warehouse Pick List';
        Text002: label 'Warehouse Movement List';
        Text003: label 'Warehouse Activity List';
        Text004: label 'Inventory Put-away List';
        Text005: label 'Inventory Pick List';
        Text006: label 'Inventory Movement List';

    local procedure FormCaption(): Text[250]
    begin
        case Type of
          Type::"Put-away":
            exit(Text000);
          Type::Pick:
            exit(Text001);
          Type::Movement:
            exit(Text002);
          Type::"Invt. Put-away":
            exit(Text004);
          Type::"Invt. Pick":
            exit(Text005);
          Type::"Invt. Movement":
            exit(Text006);
          else
            exit(Text003);
        end;
    end;
}

