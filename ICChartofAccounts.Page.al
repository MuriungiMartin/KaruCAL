#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 605 "IC Chart of Accounts"
{
    ApplicationArea = Basic;
    Caption = 'IC Chart of Accounts';
    PageType = List;
    SourceTable = "IC G/L Account";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Map-to G/L Acc. No.";"Map-to G/L Acc. No.")
                {
                    ApplicationArea = Basic;
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
            group("IC A&ccount")
            {
                Caption = 'IC A&ccount';
                Image = Intercompany;
                action("&Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "IC G/L Account Card";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Map to Acc. with Same No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Map to Acc. with Same No.';
                    Image = MapAccounts;

                    trigger OnAction()
                    var
                        ICGLAcc: Record "IC G/L Account";
                        ICMapping: Codeunit "IC Mapping";
                    begin
                        CurrPage.SetSelectionFilter(ICGLAcc);
                        if ICGLAcc.Find('-') and Confirm(Text000) then
                          repeat
                            ICMapping.MapAccounts(ICGLAcc);
                          until ICGLAcc.Next = 0;
                    end;
                }
                action("Copy from Chart of Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy from Chart of Accounts';
                    Image = CopyFromChartOfAccounts;

                    trigger OnAction()
                    begin
                        CopyFromChartOfAccounts;
                    end;
                }
                action("In&dent IC Chart of Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'In&dent IC Chart of Accounts';
                    Image = Indent;

                    trigger OnAction()
                    var
                        IndentCOA: Codeunit "G/L Account-Indent";
                    begin
                        IndentCOA.RunICAccountIndent;
                    end;
                }
                separator(Action21)
                {
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        ImportFromXML;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        ExportToXML;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    var
        Text000: label 'Are you sure you want to map the selected lines?';
        Text001: label 'Select file to import into %1';
        Text002: label 'ICGLAcc.xml';
        Text004: label 'Are you sure you want to copy from %1?';
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        Text005: label 'Enter the file name.';
        Text006: label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';

    local procedure CopyFromChartOfAccounts()
    var
        GLAcc: Record "G/L Account";
        ICGLAcc: Record "IC G/L Account";
        ChartofAcc: Page "Chart of Accounts";
        ICGLAccEmpty: Boolean;
        ICGLAccExists: Boolean;
        PrevIndentation: Integer;
    begin
        if not Confirm(Text004,false,ChartofAcc.Caption) then
          exit;

        ICGLAccEmpty := not ICGLAcc.FindFirst;
        ICGLAcc.LockTable;
        if GLAcc.Find('-') then
          repeat
            if GLAcc."Account Type" = GLAcc."account type"::"End-Total" then
              PrevIndentation := PrevIndentation - 1;
            if not ICGLAccEmpty then
              ICGLAccExists := ICGLAcc.Get(GLAcc."No.");
            if not ICGLAccExists and not GLAcc.Blocked then begin
              ICGLAcc.Init;
              ICGLAcc."No." := GLAcc."No.";
              ICGLAcc.Name := GLAcc.Name;
              ICGLAcc."Account Type" := GLAcc."Account Type";
              ICGLAcc."Income/Balance" := GLAcc."Income/Balance";
              ICGLAcc.Indentation := PrevIndentation;
              ICGLAcc.Insert;
            end;
            PrevIndentation := GLAcc.Indentation;
            if GLAcc."Account Type" = GLAcc."account type"::"Begin-Total" then
              PrevIndentation := PrevIndentation + 1;
          until GLAcc.Next = 0;
    end;

    local procedure ImportFromXML()
    var
        CompanyInfo: Record "Company Information";
        ICGLAccIO: XmlPort "IC G/L Account Import/Export";
        IFile: File;
        IStr: InStream;
        FileName: Text[1024];
        StartFileName: Text[1024];
    begin
        CompanyInfo.Get;

        StartFileName := CompanyInfo."IC Inbox Details";
        if StartFileName <> '' then begin
          if StartFileName[StrLen(StartFileName)] <> '\' then
            StartFileName := StartFileName + '\';
          StartFileName := StartFileName + '*.xml';
        end;

        if not Upload(StrSubstNo(Text001,TableCaption),'',Text006,StartFileName,FileName) then
          Error(Text005);

        IFile.Open(FileName);
        IFile.CreateInstream(IStr);
        ICGLAccIO.SetSource(IStr);
        ICGLAccIO.Import;
    end;

    local procedure ExportToXML()
    var
        CompanyInfo: Record "Company Information";
        FileMgt: Codeunit "File Management";
        ICGLAccIO: XmlPort "IC G/L Account Import/Export";
        OFile: File;
        OStr: OutStream;
        FileName: Text;
        DefaultFileName: Text;
    begin
        CompanyInfo.Get;

        DefaultFileName := CompanyInfo."IC Inbox Details";
        if DefaultFileName <> '' then
          if DefaultFileName[StrLen(DefaultFileName)] <> '\' then
            DefaultFileName := DefaultFileName + '\';
        DefaultFileName := DefaultFileName + Text002;

        FileName := FileMgt.ServerTempFileName('xml');
        if FileName = '' then
          exit;

        OFile.Create(FileName);
        OFile.CreateOutstream(OStr);
        ICGLAccIO.SetDestination(OStr);
        ICGLAccIO.Export;
        OFile.Close;
        Clear(OStr);

        Download(FileName,'Export',TemporaryPath,'',DefaultFileName);
    end;

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;
}

