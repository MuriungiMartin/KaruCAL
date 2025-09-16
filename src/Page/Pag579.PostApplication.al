#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 579 "Post Application"
{
    Caption = 'Post Application';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocNo;DocNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number of the entry to be applied.';
                }
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the entry to be applied.';
                }
            }
        }
    }

    actions
    {
    }

    var
        DocNo: Code[20];
        PostingDate: Date;


    procedure SetValues(NewDocNo: Code[20];NewPostingDate: Date)
    begin
        DocNo := NewDocNo;
        PostingDate := NewPostingDate;
    end;


    procedure GetValues(var NewDocNo: Code[20];var NewPostingDate: Date)
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
    end;
}

