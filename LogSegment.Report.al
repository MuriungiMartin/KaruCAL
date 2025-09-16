#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5185 "Log Segment"
{
    Caption = 'Log Segment';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header";"Segment Header")
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_7133; 7133)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SegManagement.LogSegment("Segment Header",Send,FollowUp);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("No.",SegmentNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Deliver;Send)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Send Attachments';
                        Enabled = DeliverEnable;
                        ToolTip = 'Specifies if you want to deliver the attachments and send them by e-mail or fax, or print them when you choose OK.';
                    }
                    field(FollowUp;FollowUp)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Create Follow-up Segment';
                        ToolTip = 'Specifies if you want to create a new segment that Specifies the same contacts when you choose OK.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DeliverEnable := true;
        end;

        trigger OnOpenPage()
        var
            SegLine: Record "Segment Line";
        begin
            SegLine.SetRange("Segment No.",SegmentNo);
            SegLine.SetFilter("Correspondence Type",'<>0');
            Send := SegLine.FindFirst;
            DeliverEnable := Send;
        end;
    }

    labels
    {
    }

    var
        SegManagement: Codeunit SegManagement;
        SegmentNo: Code[20];
        Send: Boolean;
        FollowUp: Boolean;
        [InDataSet]
        DeliverEnable: Boolean;


    procedure SetSegmentNo(SegmentFilter: Code[20])
    begin
        SegmentNo := SegmentFilter;
    end;


    procedure InitializeRequest(SendFrom: Boolean;FollowUpFrom: Boolean)
    begin
        Send := SendFrom;
        FollowUp := FollowUpFrom;
    end;
}

