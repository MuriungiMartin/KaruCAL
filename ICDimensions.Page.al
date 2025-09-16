#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 600 "IC Dimensions"
{
    ApplicationArea = Basic;
    Caption = 'IC Dimensions';
    PageType = List;
    SourceTable = "IC Dimension";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Map-to Dimension Code";"Map-to Dimension Code")
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
            group("IC &Dimension")
            {
                Caption = 'IC &Dimension';
                action("IC Dimension &Values")
                {
                    ApplicationArea = Basic;
                    Caption = 'IC Dimension &Values';
                    Image = ChangeDimensions;
                    RunObject = Page "IC Dimension Values";
                    RunPageLink = "Dimension Code"=field(Code);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Map to Dim. with Same Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Map to Dim. with Same Code';
                    Image = MapDimensions;

                    trigger OnAction()
                    var
                        ICDimension: Record "IC Dimension";
                        ICMapping: Codeunit "IC Mapping";
                    begin
                        CurrPage.SetSelectionFilter(ICDimension);
                        if ICDimension.Find('-') and Confirm(Text000) then
                          repeat
                            ICMapping.MapIncomingICDimensions(ICDimension);
                          until ICDimension.Next = 0;
                    end;
                }
                action("Copy from Dimensions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy from Dimensions';
                    Image = CopyDimensions;

                    trigger OnAction()
                    begin
                        CopyFromDimensions;
                    end;
                }
                separator(Action14)
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

    var
        Text000: label 'Are you sure you want to map the selected lines?';
        Text001: label 'Select file to import into %1';
        Text002: label 'ICDim.xml';
        Text004: label 'Are you sure you want to copy from Dimensions?';
        Text005: label 'Enter the file name.';
        Text006: label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';

    local procedure CopyFromDimensions()
    var
        Dim: Record Dimension;
        DimVal: Record "Dimension Value";
        ICDim: Record "IC Dimension";
        ICDimVal: Record "IC Dimension Value";
        ICDimValEmpty: Boolean;
        ICDimValExists: Boolean;
        PrevIndentation: Integer;
    begin
        if not Confirm(Text004,false) then
          exit;

        ICDimVal.LockTable;
        ICDim.LockTable;
        Dim.SetRange(Blocked,false);
        if Dim.Find('-') then
          repeat
            if not ICDim.Get(Dim.Code) then begin
              ICDim.Init;
              ICDim.Code := Dim.Code;
              ICDim.Name := Dim.Name;
              ICDim.Insert;
            end;

            ICDimValExists := false;
            DimVal.SetRange("Dimension Code",Dim.Code);
            ICDimVal.SetRange("Dimension Code",Dim.Code);
            ICDimValEmpty := not ICDimVal.FindFirst;
            if DimVal.Find('-') then
              repeat
                if DimVal."Dimension Value Type" = DimVal."dimension value type"::"End-Total" then
                  PrevIndentation := PrevIndentation - 1;
                if not ICDimValEmpty then
                  ICDimValExists := ICDimVal.Get(DimVal."Dimension Code",DimVal.Code);
                if not ICDimValExists and not DimVal.Blocked then begin
                  ICDimVal.Init;
                  ICDimVal."Dimension Code" := DimVal."Dimension Code";
                  ICDimVal.Code := DimVal.Code;
                  ICDimVal.Name := DimVal.Name;
                  ICDimVal."Dimension Value Type" := DimVal."Dimension Value Type";
                  ICDimVal.Indentation := PrevIndentation;
                  ICDimVal.Insert;
                end;
                PrevIndentation := DimVal.Indentation;
                if DimVal."Dimension Value Type" = DimVal."dimension value type"::"Begin-Total" then
                  PrevIndentation := PrevIndentation + 1;
              until DimVal.Next = 0;
          until Dim.Next = 0;
    end;

    local procedure ImportFromXML()
    var
        CompanyInfo: Record "Company Information";
        ICDimIO: XmlPort "IC Dimension Import/Export";
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
        ICDimIO.SetSource(IStr);
        ICDimIO.Import;
    end;

    local procedure ExportToXML()
    var
        CompanyInfo: Record "Company Information";
        FileMgt: Codeunit "File Management";
        ICDimIO: XmlPort "IC Dimension Import/Export";
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
        ICDimIO.SetDestination(OStr);
        ICDimIO.Export;
        OFile.Close;
        Clear(OStr);

        Download(FileName,'Export',TemporaryPath,'',DefaultFileName);
    end;
}

