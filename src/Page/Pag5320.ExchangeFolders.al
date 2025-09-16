#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5320 "Exchange Folders"
{
    Caption = 'Exchange Folders';
    Editable = false;
    PageType = List;
    RefreshOnActivate = false;
    ShowFilter = false;
    SourceTable = "Exchange Folder";
    SourceTableTemporary = true;
    SourceTableView = sorting(FullPath)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                IndentationColumn = Depth;
                IndentationControls = Name;
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowAsTree = true;
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Folder Name';
                    ToolTip = 'Specifies the name of the public folder that is specified for use with email logging.';
                }
                field(FullPath;FullPath)
                {
                    ApplicationArea = Basic;
                    Caption = 'Folder Path';
                    ToolTip = 'Specifies the complete path to the public folder that is specified for use with email logging.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetChildren)
            {
                ApplicationArea = Basic;
                Caption = 'Get subfolders';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                var
                    SelectedExchangeFolder: Record "Exchange Folder";
                    HasChildren: Boolean;
                begin
                    if not Cached then begin
                      SelectedExchangeFolder := Rec;
                      HasChildren := ExchangeWebServicesClient.GetPublicFolders(Rec);
                      CurrPage.SetRecord(SelectedExchangeFolder);
                      if HasChildren then
                        Next;
                    end;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        // This has to be called before GETRECORD that copies the content
        CalcFields("Unique ID");
    end;

    trigger OnOpenPage()
    begin
        if not ExchangeWebServicesClient.ReadBuffer(Rec) then
          ExchangeWebServicesClient.GetPublicFolders(Rec);
        if FindFirst then;
        CurrPage.Update(false);
    end;

    var
        ExchangeWebServicesClient: Codeunit "Exchange Web Services Client";


    procedure Initialize(ExchWebServicesClient: Codeunit "Exchange Web Services Client";Caption: Text)
    begin
        ExchangeWebServicesClient := ExchWebServicesClient;
        CurrPage.Caption := Caption;
    end;
}

