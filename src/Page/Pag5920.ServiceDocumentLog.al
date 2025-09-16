#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5920 "Service Document Log"
{
    ApplicationArea = Basic;
    Caption = 'Service Document Log';
    DataCaptionExpression = GetCaptionHeader;
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Service Document Log";
    SourceTableView = sorting("Change Date","Change Time")
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the type of the service document that underwent changes.';
                    Visible = DocumentTypeVisible;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document that has undergone changes.';
                    Visible = DocumentNoVisible;
                }
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item line, if the event is linked to a service item line.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to this entry.';
                    Visible = false;
                }
                field("ServLogMgt.ServOrderEventDescription(""Event No."")";ServLogMgt.ServOrderEventDescription("Event No."))
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the event that occurred to a particular service document.';
                }
                field(After;After)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of the modified field after the event takes place.';
                }
                field(Before;Before)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of the modified field before the event takes place.';
                }
                field("Change Date";"Change Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the event.';
                }
                field("Change Time";"Change Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time of the event.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who performed the changes.';
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Delete Service Document Log")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Service Document Log';
                    Ellipsis = true;
                    Image = Delete;

                    trigger OnAction()
                    var
                        ServOrderLog: Record "Service Document Log";
                        DeleteServOrderLog: Report "Delete Service Document Log";
                    begin
                        ServOrderLog.SetRange("Document Type","Document Type");
                        ServOrderLog.SetRange("Document No.","Document No.");
                        DeleteServOrderLog.SetTableview(ServOrderLog);
                        DeleteServOrderLog.RunModal;

                        if DeleteServOrderLog.GetOnPostReportStatus then begin
                          ServOrderLog.Reset;
                          DeleteServOrderLog.GetServDocLog(ServOrderLog);
                          CopyFilters(ServOrderLog);
                          DeleteAll;
                          Reset;
                          SetCurrentkey("Change Date","Change Time");
                          Ascending(false);
                        end;
                    end;
                }
            }
            action("&Show")
            {
                ApplicationArea = Basic;
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServShptHeader: Record "Service Shipment Header";
                    ServInvHeader: Record "Service Invoice Header";
                    ServCrMemoHeader: Record "Service Cr.Memo Header";
                    PageManagement: Codeunit "Page Management";
                    isError: Boolean;
                begin
                    if "Document Type" in
                       ["document type"::Order,"document type"::Quote,
                        "document type"::Invoice,"document type"::"Credit Memo"]
                    then
                      if ServOrderHeaderRec.Get("Document Type","Document No.") then begin
                        isError := false;
                        PageManagement.PageRun(ServOrderHeaderRec);
                      end else
                        isError := true
                    else begin // posted documents
                      isError := true;
                      case "Document Type" of
                        "document type"::Shipment:
                          if ServShptHeader.Get("Document No.") then begin
                            isError := false;
                            Page.Run(Page::"Posted Service Shipment",ServShptHeader);
                          end;
                        "document type"::"Posted Invoice":
                          if ServInvHeader.Get("Document No.") then begin
                            isError := false;
                            Page.Run(Page::"Posted Service Invoice",ServInvHeader);
                          end;
                        "document type"::"Posted Credit Memo":
                          if ServCrMemoHeader.Get("Document No.") then begin
                            isError := false;
                            Page.Run(Page::"Posted Service Credit Memo",ServCrMemoHeader);
                          end;
                      end;
                    end;
                    if isError then
                      Error(Text001,"Document Type","Document No.");
                end;
            }
        }
    }

    trigger OnInit()
    begin
        DocumentNoVisible := true;
        DocumentTypeVisible := true;
    end;

    var
        ServOrderHeaderRec: Record "Service Header";
        ServLogMgt: Codeunit ServLogManagement;
        Text001: label 'Service %1 %2 does not exist.', Comment='Service Order 2001 does not exist.';
        [InDataSet]
        DocumentTypeVisible: Boolean;
        [InDataSet]
        DocumentNoVisible: Boolean;

    local procedure GetCaptionHeader(): Text[250]
    var
        ServHeader: Record "Service Header";
    begin
        if GetFilter("Document No.") <> '' then begin
          DocumentTypeVisible := false;
          DocumentNoVisible := false;
          if ServHeader.Get("Document Type","Document No.") then
            exit(Format("Document Type") + ' ' + "Document No." + ' ' + ServHeader.Description);

          exit(Format("Document Type") + ' ' + "Document No.");
        end;

        DocumentTypeVisible := true;
        DocumentNoVisible := true;
        exit('');
    end;
}

