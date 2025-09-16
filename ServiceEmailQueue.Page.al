#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5961 "Service Email Queue"
{
    ApplicationArea = Basic;
    Caption = 'Service Email Queue';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Service Email Queue";
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
                    Editable = false;
                    ToolTip = 'Specifies the type of document linked to this entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the document linked to this entry.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the message status.';
                }
                field("Sending Date";"Sending Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date the message was sent.';
                }
                field("Sending Time";"Sending Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time the message was sent.';
                }
                field("To Address";"To Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address of the recipient when an email is sent to notify customers that their service items are ready.';
                }
                field("Subject Line";"Subject Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email subject line.';
                }
                field("Body Line";"Body Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the text of the body of the email.';
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
            group("&Queue")
            {
                Caption = '&Queue';
                Image = CheckList;
                action("&Send by Email")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send by Email';
                    Image = Email;

                    trigger OnAction()
                    begin
                        if IsEmpty then
                          Error(Text001);

                        if Status = Status::Processed then
                          Error(Text000);

                        Clear(ServMailMgt);

                        ClearLastError;

                        if ServMailMgt.Run(Rec) then begin
                          Status := Status::Processed;
                          CurrPage.Update;
                        end else
                          Error(GetLastErrorText);
                    end;
                }
                action("&Delete Service Order Email Queue")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Service Order Email Queue';
                    Ellipsis = true;
                    Image = Delete;

                    trigger OnAction()
                    var
                        EMailQueue: Record "Service Email Queue";
                    begin
                        Clear(EMailQueue);
                        EMailQueue.SetCurrentkey("Document Type","Document No.");
                        EMailQueue.SetRange("Document Type","Document Type");
                        EMailQueue.SetRange("Document No.","Document No.");
                        Report.Run(Report::"Delete Service Email Queue",false,false,EMailQueue);
                    end;
                }
                action("D&elete Service Email Queue")
                {
                    ApplicationArea = Basic;
                    Caption = 'D&elete Service Email Queue';
                    Image = Delete;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Delete Service Email Queue");
                    end;
                }
            }
        }
    }

    var
        Text000: label 'This email  has already been sent.';
        Text001: label 'There are no items to process.';
        ServMailMgt: Codeunit ServMailManagement;
}

