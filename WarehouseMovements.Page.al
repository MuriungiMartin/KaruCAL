#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9314 "Warehouse Movements"
{
    ApplicationArea = Basic;
    Caption = 'Warehouse Movements';
    CardPageID = "Warehouse Movement";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Activity Header";
    SourceTableView = where(Type=const(Movement));
    UsageCategory = Lists;

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
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the user was assigned the activity.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Movement")
            {
                Caption = '&Movement';
                Image = CreateMovement;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Whse. Activity Header"),
                                  Type=field(Type),
                                  "No."=field("No.");
                }
                action("Registered Movements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Movements';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Activity List";
                    RunPageLink = Type=field(Type),
                                  "Whse. Activity No."=field("No.");
                    RunPageView = sorting("Whse. Activity No.");
                }
            }
        }
    }

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
}

