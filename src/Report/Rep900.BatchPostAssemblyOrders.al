#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 900 "Batch Post Assembly Orders"
{
    Caption = 'Batch Post Assembly Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Assembly Header";"Assembly Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.";
            column(ReportForNavId_3252; 3252)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1,"No.");
                Window.Update(2,ROUND(Counter / CounterTotal * 10000,1));
                Clear(AssemblyPost);
                AssemblyPost.SetPostingDate(ReplacePostingDate,PostingDateReq);
                if AssemblyPost.Run("Assembly Header") then begin
                  CounterOK := CounterOK + 1;
                  if MarkedOnly then
                    Mark(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002,CounterOK,CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                  Error(Text000);

                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(ReplacePostingDate;ReplacePostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Replace Posting Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ReplacePostingDate := false;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Posting orders  #1########## @2@@@@@@@@@@@@@';
        Text002: label '%1 orders out of a total of %2 have now been posted.';
        AssemblyPost: Codeunit "Assembly-Post";
        Window: Dialog;
        PostingDateReq: Date;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplacePostingDate: Boolean;


    procedure InitializeRequest(NewPostingDateReq: Date;NewReplacePostingDate: Boolean)
    begin
        PostingDateReq := NewPostingDateReq;
        ReplacePostingDate := NewReplacePostingDate;
    end;
}

