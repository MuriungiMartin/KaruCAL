#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 491 "Delete Invd Blnkt Purch Orders"
{
    Caption = 'Delete Invd Blnkt Purch Orders';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Blanket Order"));
            RequestFilterFields = "No.","Buy-from Vendor No.","Pay-to Vendor No.";
            RequestFilterHeading = 'Blanket Purchase Order';
            column(ReportForNavId_4458; 4458)
            {
            }

            trigger OnAfterGetRecord()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                Window.Update(1,"No.");

                PurchLine.Reset;
                PurchLine.SetRange("Document Type","Document Type");
                PurchLine.SetRange("Document No.","No.");
                PurchLine.SetFilter("Quantity Invoiced",'<>0');
                if PurchLine.FindFirst then begin
                  PurchLine.SetRange("Quantity Invoiced");
                  PurchLine.SetFilter("Outstanding Quantity",'<>0');
                  if not PurchLine.FindFirst then begin
                    PurchLine.SetRange("Outstanding Quantity");
                    PurchLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
                    if not PurchLine.FindFirst then begin
                      PurchLine.LockTable;
                      if not PurchLine.FindFirst then begin
                        PurchLine.SetRange("Qty. Rcd. Not Invoiced");
                        PurchLine2.SetRange("Blanket Order No.","No.");
                        if not PurchLine2.FindFirst then begin
                          PurchLine.DeleteAll;

                          PurchCommentLine.SetRange("Document Type","Document Type");
                          PurchCommentLine.SetRange("No.","No.");
                          PurchCommentLine.DeleteAll;

                          ApprovalsMgmt.DeleteApprovalEntry("Purchase Header");

                          Delete;

                          Commit;
                        end;
                      end;
                    end;
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Processing purch. orders #1##########';
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        Window: Dialog;
}

