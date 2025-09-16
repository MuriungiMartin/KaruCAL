#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5832 "Capacity Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Capacity Ledger Entries';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Capacity Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date of the entry.';
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of order the entry was created in.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                }
                field("Routing No.";"Routing No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the routing number belonging to the entry.';
                    Visible = false;
                }
                field("Routing Reference No.";"Routing Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the routing reference number corresponding to the routing reference number of the line.';
                    Visible = false;
                }
                field("Work Center No.";"Work Center No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the work center.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of capacity entry.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number (code) belonging to the entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the entry.';
                    Visible = false;
                }
                field("Operation No.";"Operation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the operation associated with the entry.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Work Shift Code";"Work Shift Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the work shift that this machine center was planned at, or in which work shift the related production operation took place.';
                    Visible = false;
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting time of the capacity posted with this entry.';
                    Visible = false;
                }
                field("Ending Time";"Ending Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending time of the capacity posted with this entry.';
                    Visible = false;
                }
                field("Concurrent Capacity";"Concurrent Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many people have worked concurrently on this entry.';
                    Visible = false;
                }
                field("Setup Time";"Setup Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how long it takes to set up the machines for this entry.';
                    Visible = false;
                }
                field("Run Time";"Run Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the run time of this entry.';
                    Visible = false;
                }
                field("Stop Time";"Stop Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the stop time of this entry.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of this entry, in base units of measure.';
                }
                field("Output Quantity";"Output Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the output quantity, in base units of measure.';
                }
                field("Scrap Quantity";"Scrap Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the scrap quantity, in base units of measure.';
                }
                field("Direct Cost";"Direct Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direct cost in $ of the quantity posting.';
                }
                field("Overhead Cost";"Overhead Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the overhead cost in $ of the quantity posting.';
                }
                field("Direct Cost (ACY)";"Direct Cost (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direct cost in the additional reporting currency.';
                    Visible = false;
                }
                field("Overhead Cost (ACY)";"Overhead Cost (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the overhead cost in the additional reporting currency.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code the posted entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code the posted entry is linked to.';
                    Visible = false;
                }
                field("Stop Code";"Stop Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the stop code.';
                    Visible = false;
                }
                field("Scrap Code";"Scrap Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies why an item has been scrapped.';
                    Visible = false;
                }
                field("Completely Invoiced";"Completely Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the entry has been fully invoiced or if more posted invoices are expected.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the consecutive number assigned to this entry.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("&Value Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Capacity Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Capacity Ledger Entry No.","Entry Type");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    if "Order Type" = "order type"::Production then
                      Navigate.SetDoc("Posting Date","Order No.")
                    else
                      Navigate.SetDoc("Posting Date",'');
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Text000: label 'Machine Center';

    local procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        ProdOrder: Record "Production Order";
        SourceTableName: Text[100];
        SourceFilter: Text;
        Description: Text[100];
    begin
        Description := '';

        case true of
          GetFilter("Work Center No.") <> '':
            begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,99000754);
              SourceFilter := GetFilter("Work Center No.");
              if MaxStrLen(WorkCenter."No.") >= StrLen(SourceFilter) then
                if WorkCenter.Get(SourceFilter) then
                  Description := WorkCenter.Name;
            end;
          (GetFilter("No.") <> '') and (GetFilter(Type) = Text000):
            begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,99000758);
              SourceFilter := GetFilter("No.");
              if MaxStrLen(MachineCenter."No.") >= StrLen(SourceFilter) then
                if MachineCenter.Get(SourceFilter) then
                  Description := MachineCenter.Name;
            end;
          (GetFilter("Order No.") <> '') and ("Order Type" = "order type"::Production):
            begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,5405);
              SourceFilter := GetFilter("Order No.");
              if MaxStrLen(ProdOrder."No.") >= StrLen(SourceFilter) then
                if ProdOrder.Get(ProdOrder.Status::Released,SourceFilter) or
                   ProdOrder.Get(ProdOrder.Status::Finished,SourceFilter)
                then begin
                  SourceTableName := StrSubstNo('%1 %2',ProdOrder.Status,SourceTableName);
                  Description := ProdOrder.Description;
                end;
            end;
        end;
        exit(StrSubstNo('%1 %2 %3',SourceTableName,SourceFilter,Description));
    end;
}

