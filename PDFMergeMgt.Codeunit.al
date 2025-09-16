#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80000 "PDFMerge Mgt"
{

    trigger OnRun()
    begin
        /*
        "\\intechserver\Shared\Test\Hirel\PdfMerge.exe" output="\\intec
        hserver\Shared\Test\Hirel\result.pdf" input="\\intechserver\Shared\Test\Hirel\PO
        RD1415UN200442525022016_192748.pdf","\\intechserver\Shared\Test\Hirel\GTC.pdf"
         */

    end;

    var
        Text50000_gCtx: label 'Purchase Order %1 Must be Authorized to Print.';
        Text000: label '%1\PdfMerge output=%2 input=%3,%4';


    procedure MergePDFFile_gFnc(CMDCmd_iTxt: Text)
    var
        CMDCmd_lTxt: Text;
        WShell_gAut: Automation WshShell;
        DummyInt_gInt: Integer;
        WaitOnReturn_gBln: Boolean;
    begin
        Clear(WShell_gAut);
        DummyInt_gInt := 0;  //0 = to Hide CMS Screen and 1
        WaitOnReturn_gBln := false;
        Create(WShell_gAut,false,true);
        WShell_gAut.Run(CMDCmd_iTxt,DummyInt_gInt,WaitOnReturn_gBln);
        Clear(WShell_gAut);
    end;


    procedure "------- Merge PDF Document -------------"()
    begin
    end;


    procedure POandTermsPrint_gFnc(PurchHdr_iRec: Record "Purchase Header")
    var
        PH_lRec: Record "Purchase Header";
        PurchSetup: Record UnknownRecord80000;
        POCode_lCod: Code[20];
        ServerFileName_lTxt: Text;
        ServerSharedPath_lTxt: Text;
        UniqueString_lTxt: Text;
        CMDCommand_lTxt: Text;
        POTermFile_lTxt: Text;
        OutputFilePath_lTxt: Text;
        R50183: Report UnknownReport80002;
        R405: Report UnknownReport80000;
        NewNoOfCopies: Integer;
        NewShowInternalInfo: Boolean;
        NewArchiveDocument: Boolean;
        NewLogInteraction: Boolean;
        ExciseInclusive_iBln: Boolean;
        ExciseAtActual_iBln: Boolean;
        VATInclusive_iBln: Boolean;
        VATAtActual_iBln: Boolean;
        BOMprint_iBln: Boolean;
    begin
        if PurchHdr_iRec.Status <> PurchHdr_iRec.Status :: Released then
          Error(Text50000_gCtx,PurchHdr_iRec."No.");

        PH_lRec.Reset;
        PH_lRec.SetRange("Document Type",PurchHdr_iRec."Document Type");
        PH_lRec.SetRange("No.",PurchHdr_iRec."No.");
        Clear(R50183);
        R50183.SetTableview(PH_lRec);
        R50183.RunModal;
        R50183.InitializeRequestPDF_gFnc(NewNoOfCopies,NewShowInternalInfo,NewArchiveDocument,NewLogInteraction,ExciseInclusive_iBln,ExciseAtActual_iBln,VATInclusive_iBln,VATAtActual_iBln,BOMprint_iBln);

        Clear(R405);
        R405.InitializeRequestPDF_gFnc(NewNoOfCopies,NewShowInternalInfo,NewArchiveDocument,NewLogInteraction,ExciseInclusive_iBln,ExciseAtActual_iBln,VATInclusive_iBln,VATAtActual_iBln,BOMprint_iBln);
        R405.UseRequestPage(false);
        R405.SetTableview(PH_lRec);


        PurchSetup.Get;
        PurchSetup.TestField("PDF Merge Shared Folder");

        POCode_lCod := DelChr(PurchHdr_iRec."No.",'=','#%&*:<>?\/{|}~');

        ServerSharedPath_lTxt := PurchSetup."PDF Merge Shared Folder";
        UpdatePath_gFnc(ServerSharedPath_lTxt);
        UniqueString_lTxt := POCode_lCod + Format(Today,0,'<Day,2><Month,2><Year4>') + '_' + Format(Time,0,'<Hours24,2><Minutes,2><Seconds,2>');


        ServerFileName_lTxt := ServerSharedPath_lTxt + UniqueString_lTxt + '.pdf';  //Need to erase

        //REPORT.SAVEASPDF(REPORT::Order,ServerFileName_lTxt,PH_lRec);
        R405.SaveAsPdf(ServerFileName_lTxt);

        POTermFile_lTxt := ServerSharedPath_lTxt + 'GTC.pdf';
        if not Exists(POTermFile_lTxt) then
          Error('File does not exists - %1',POTermFile_lTxt);

        OutputFilePath_lTxt := ServerSharedPath_lTxt + UniqueString_lTxt + '_' + '.pdf';  //Need to Delete

        CMDCommand_lTxt := StrSubstNo(Text000,ServerSharedPath_lTxt,OutputFilePath_lTxt,ServerFileName_lTxt,POTermFile_lTxt);

        //\\intechserver\Shared\Test\Hirel\PdfMerge.exe" output="\\intechserver\Shared\Test\Hirel\result.pdf" input="\\intechserver\Shared\Test\Hirel\PO
        //RD1415UN200442525022016_192748.pdf","\\intechserver\Shared\Test\Hirel\GTC.pdf

        MergePDFFile_gFnc(CMDCommand_lTxt);

        Sleep(3000);

        if Exists(OutputFilePath_lTxt) then
          ExportAttToClientFile_gFnc(OutputFilePath_lTxt,POCode_lCod + '.pdf')
        else begin
          Sleep(6000);
          if Exists(OutputFilePath_lTxt) then
            ExportAttToClientFile_gFnc(OutputFilePath_lTxt,POCode_lCod + '.pdf');
        end;

        if Exists(ServerFileName_lTxt) then
          Erase(ServerFileName_lTxt);

        if Exists(OutputFilePath_lTxt) then
          Erase(OutputFilePath_lTxt);
    end;


    procedure UpdatePath_gFnc(var Path_vTxt: Text[250])
    begin
        if CopyStr(Path_vTxt,StrLen(Path_vTxt),1) <> '\' then
          Path_vTxt := Path_vTxt + '\';
    end;


    procedure ExportAttToClientFile_gFnc(var ExportToFile: Text;ImportFileName_iTxt: Text[250]): Boolean
    var
        FileMgmt_lCdu: Codeunit "File Management";
        FileExtension_lTxt: Text[100];
        FileFilter_lTxt: Text[100];
        Text024_gTxt: label 'Export File';
    begin
        FileExtension_lTxt := FileMgmt_lCdu.GetExtension(ExportToFile);
        FileFilter_lTxt := UpperCase(FileExtension_lTxt) + ' (*.' + FileExtension_lTxt + ')|*.' + FileExtension_lTxt;
        Download(ExportToFile,Text024_gTxt,'',FileFilter_lTxt,ImportFileName_iTxt);
    end;
}

