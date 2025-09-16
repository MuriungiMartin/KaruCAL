#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5965 "Service Quote Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Item Line";
    SourceTableView = where("Document Type"=const(Quote));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item number registered in the Service Item table.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ServOrderMgt: Codeunit ServOrderManagement;
                    begin
                        ServOrderMgt.LookupServItemNo(Rec);
                        if xRec.Get("Document Type","Document No.","Line No.") then;
                    end;
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service item group for this item.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code of the service item associated with the service contract or service order.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number linked to this service item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this item.';

                    trigger OnAssistEdit()
                    begin
                        AssistEditSerialNo;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of this service item.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of this item.';
                    Visible = false;
                }
                field("Repair Status Code";"Repair Status Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the repair status of this service item.';
                }
                field("Service Shelf No.";"Service Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service shelf this item is stored on.';
                    Visible = false;
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that warranty on either parts or labor exists for this item.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the spare parts warranty for this item.';
                    Visible = false;
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending date of the spare parts warranty for this item.';
                    Visible = false;
                }
                field("Warranty % (Parts)";"Warranty % (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of spare parts costs covered by the warranty for this item.';
                    Visible = false;
                }
                field("Warranty % (Labor)";"Warranty % (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of labor costs covered by the warranty for this item.';
                    Visible = false;
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the labor warranty for this item.';
                    Visible = false;
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending date of the labor warranty for this item.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service contract associated with the item or service on the line.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault reason code for the item.';
                    Visible = false;
                }
                field("Service Price Group Code";"Service Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service price group associated with the item.';
                    Visible = false;
                }
                field("Adjustment Type";"Adjustment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the adjustment type for the line.';
                    Visible = false;
                }
                field("Base Amount to Adjust";"Base Amount to Adjust")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that the service line, linked to this service item line, will be adjusted to.';
                    Visible = false;
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault area code for this item.';
                    Visible = false;
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the symptom code for this item.';
                    Visible = false;
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault code for this item.';
                    Visible = false;
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resolution code for this item.';
                    Visible = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service priority for this item.';
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated hours from order creation, to the time when the repair status of the item line changes from Initial, to In Process.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when service should start on this service item line.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time when service should start on this service item.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor of this item.';
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to the service item by its vendor.';
                    Visible = false;
                }
                field("Loaner No.";"Loaner No.")
                {
                    ApplicationArea = Basic;
                    LookupPageID = "Available Loaners";
                    ToolTip = 'Specifies the number of the loaner that has been lent to the customer in the service order to replace this item.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service on this item began and when the repair status changed to In process.';
                    Visible = false;
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when service on this item began and when the repair status changed to In process.';
                    Visible = false;
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finishing date of the service and when the repair status of this item changes to Finished.';
                    Visible = false;
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finishing time of the service and when the repair status of this item changes to Finished.';
                    Visible = false;
                }
                field("No. of Previous Services";"No. of Previous Services")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of services performed on service items with the same item and serial number as this service item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Resource &Allocations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource &Allocations';
                    Image = ResourcePlanning;

                    trigger OnAction()
                    begin
                        AllocateResource;
                    end;
                }
                action("Service &Item Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Item Worksheet';
                    Image = ServiceItemWorksheet;

                    trigger OnAction()
                    begin
                        ShowServOrderWorksheet;
                    end;
                }
                action(Troubleshooting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;

                    trigger OnAction()
                    begin
                        ShowChecklist;
                    end;
                }
                action("&Fault/Resol. Codes Relations")
                {
                    ApplicationArea = Basic;
                    Caption = '&Fault/Resol. Codes Relations';

                    trigger OnAction()
                    begin
                        ShowFaultResolutionRelation;
                    end;
                }
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
                group("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    action(Faults)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Faults';
                        Image = Error;

                        trigger OnAction()
                        begin
                            ShowComments(1);
                        end;
                    }
                    action(Resolutions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resolutions';
                        Image = Completed;

                        trigger OnAction()
                        begin
                            ShowComments(2);
                        end;
                    }
                    action(Internal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Internal';
                        Image = Comment;

                        trigger OnAction()
                        begin
                            ShowComments(4);
                        end;
                    }
                    action(Accessories)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Accessories';
                        Image = ServiceAccessories;

                        trigger OnAction()
                        begin
                            ShowComments(3);
                        end;
                    }
                    action("Lent Loaners")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lent Loaners';

                        trigger OnAction()
                        begin
                            ShowComments(5);
                        end;
                    }
                }
                action("Service Item &Log")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item &Log';
                    Image = Log;

                    trigger OnAction()
                    begin
                        ShowServItemEventLog;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Receive Loaner")
                {
                    ApplicationArea = Basic;
                    Caption = '&Receive Loaner';
                    Image = ReceiveLoaner;

                    trigger OnAction()
                    begin
                        ReceiveLoaner;
                    end;
                }
                action("Create Service &Item")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Service &Item';

                    trigger OnAction()
                    begin
                        CreateServItemOnServItemLine;
                    end;
                }
                action("Get St&d. Service Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Service Codes';
                    Ellipsis = true;
                    Image = ServiceCode;

                    trigger OnAction()
                    var
                        StdServItemGrCode: Record "Standard Service Item Gr. Code";
                    begin
                        StdServItemGrCode.InsertServiceLines(Rec);
                    end;
                }
            }
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
                action(ServiceLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Lin&es';
                    Image = ServiceLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        RegisterServInvLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if "Serial No." = '' then
          "No. of Previous Services" := 0;
    end;

    trigger OnAfterGetRecord()
    begin
        if "Serial No." = '' then
          "No. of Previous Services" := 0;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;

    var
        ServLoanerMgt: Codeunit ServLoanerManagement;
        CannotOpenWindowErr: label 'You cannot open the window because %1 is %2 in the %3 table.';

    local procedure RegisterServInvLines()
    var
        ServInvLine: Record "Service Line";
        ServInvLines: Page "Service Quote Lines";
    begin
        TestField("Document No.");
        TestField("Line No.");
        Clear(ServInvLine);
        ServInvLine.SetRange("Document Type","Document Type");
        ServInvLine.SetRange("Document No.","Document No.");
        ServInvLine.FilterGroup(2);
        Clear(ServInvLines);
        ServInvLines.Initialize("Line No.");
        ServInvLines.SetTableview(ServInvLine);
        ServInvLines.RunModal;
        ServInvLine.FilterGroup(0);
    end;

    local procedure ShowServOrderWorksheet()
    var
        ServItemLine: Record "Service Item Line";
    begin
        TestField("Document No.");
        TestField("Line No.");

        Clear(ServItemLine);
        ServItemLine.SetRange("Document Type","Document Type");
        ServItemLine.SetRange("Document No.","Document No.");
        ServItemLine.FilterGroup(2);
        ServItemLine.SetRange("Line No.","Line No.");
        Page.RunModal(Page::"Service Item Worksheet",ServItemLine);
        ServItemLine.FilterGroup(0);
    end;

    local procedure AllocateResource()
    var
        ServOrderAlloc: Record "Service Order Allocation";
        ResAlloc: Page "Resource Allocations";
    begin
        TestField("Document No.");
        TestField("Line No.");
        ServOrderAlloc.Reset;
        ServOrderAlloc.SetCurrentkey("Document Type","Document No.","Service Item Line No.");
        ServOrderAlloc.FilterGroup(2);
        ServOrderAlloc.SetFilter(Status,'<>%1',ServOrderAlloc.Status::Canceled);
        ServOrderAlloc.SetRange("Document Type","Document Type");
        ServOrderAlloc.SetRange("Document No.","Document No.");
        ServOrderAlloc.FilterGroup(0);
        ServOrderAlloc.SetRange("Service Item Line No.","Line No.");
        if ServOrderAlloc.FindFirst then;
        ServOrderAlloc.SetRange("Service Item Line No.");
        Clear(ResAlloc);
        ResAlloc.SetRecord(ServOrderAlloc);
        ResAlloc.SetTableview(ServOrderAlloc);
        ResAlloc.SetRecord(ServOrderAlloc);
        ResAlloc.Run;
    end;

    local procedure ReceiveLoaner()
    begin
        ServLoanerMgt.ReceiveLoaner(Rec);
    end;

    local procedure ShowServItemEventLog()
    var
        ServItemLog: Record "Service Item Log";
    begin
        TestField("Service Item No.");
        Clear(ServItemLog);
        ServItemLog.SetRange("Service Item No.","Service Item No.");
        Page.RunModal(Page::"Service Item Log",ServItemLog);
    end;

    local procedure ShowChecklist()
    var
        TblshtgHeader: Record "Troubleshooting Header";
    begin
        TblshtgHeader.ShowForServItemLine(Rec);
    end;

    local procedure ShowFaultResolutionRelation()
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        FaultResolutionRelation: Page "Fault/Resol. Cod. Relationship";
    begin
        ServMgtSetup.Get;
        case ServMgtSetup."Fault Reporting Level" of
          ServMgtSetup."fault reporting level"::None:
            Error(
              CannotOpenWindowErr,
              ServMgtSetup.FieldCaption("Fault Reporting Level"),
              ServMgtSetup."Fault Reporting Level",
              ServMgtSetup.TableCaption);
        end;
        Clear(FaultResolutionRelation);
        FaultResolutionRelation.SetDocument(
          Database::"Service Item Line","Document Type","Document No.","Line No.");
        FaultResolutionRelation.SetFilters("Symptom Code","Fault Code","Fault Area Code","Service Item Group Code");
        FaultResolutionRelation.RunModal;
    end;

    local procedure CreateServItemOnServItemLine()
    var
        ServItemMgt: Codeunit ServItemManagement;
    begin
        ServItemMgt.CreateServItemOnServItemLine(Rec);
    end;
}

