//
//  ViewController.m
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "ViewController.h"
#import "Aluno.h"
#import "AlunoSingleton.h"
#import "FotoSingleton.h"

@interface ViewController ()
{
    AlunoSingleton *alunoSingleton;
    NSArray *alunos;
    Aluno *alunoSelecionado;
    UIToolbar *fotoToolBar;
}

@end

@implementation ViewController
@synthesize foto,imagePickerController;

- (void)viewDidLoad {
    [super viewDidLoad];
    alunoSelecionado = nil;
    alunoSingleton = [AlunoSingleton sharedInstance];
    alunos = [alunoSingleton todosAlunos];
    
    CGFloat posicaoY = self.view.bounds.size.height-44;
    CGFloat posicaoX = 0;
    CGFloat width = _tableView.bounds.size.width;
    CGFloat height = 44;
    
    fotoToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(posicaoX, posicaoY, width, height)];
    [fotoToolBar setBackgroundColor:[UIColor blackColor]];
    
    UIBarButtonItem *addFotoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(vincularFoto)];
    UIBarButtonItem *cancelarEdicao = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelarEdicao)];
    
#warning Implementar botao de remocao
    
    NSArray *itens = @[addFotoItem,cancelarEdicao];
    [fotoToolBar setItems:itens];
    [self setImageInput];
    
#warning Captura evento de rotacao de tela para recalcular posicao da toolbar
    [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Metodos privados

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obter a orientacao corrente (nao necessario neste projeto
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGFloat posicaoY = self.view.bounds.size.height-44;
    CGFloat posicaoX = 0;
    CGFloat width = _tableView.bounds.size.width;
    CGFloat height = 44;
    [fotoToolBar setFrame:CGRectMake(posicaoX, posicaoY, width, height)];
}

-(void)vincularFoto {
    if (!alunoSelecionado) {
        return;
    }
//    UIImage *foto = [UIImage imageNamed:@"smile"];
//    [[FotoSingleton sharedInstance] salvarFoto:foto comNome:alunoSelecionado.tia];
//    [_tableView reloadData];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)cancelarEdicao {
    [_nomeTextField setText:@""];
    [_tiaTextField setText:@""];
    alunoSelecionado = nil;
    [_botaoSalvar setTitle:@"Salvar" forState:UIControlStateNormal];
    [_tiaTextField setEnabled:YES];
    [fotoToolBar removeFromSuperview];
    [_tableView deselectRowAtIndexPath:[_tableView
                                              indexPathForSelectedRow] animated: YES];
}


#pragma mark - Metodos publicos

- (IBAction)salvar:(id)sender {
    [_nomeTextField resignFirstResponder];
    [_tiaTextField resignFirstResponder];
    
    if (alunoSelecionado) {
        RLMRealm *realm = [alunoSelecionado realm];
        [realm beginWriteTransaction];
        [alunoSelecionado setNome:_nomeTextField.text];
        [alunoSelecionado setTia:_tiaTextField.text];
        [realm commitWriteTransaction];
        
    } else {
        Aluno *novoAluno = [[Aluno alloc] init];
        [novoAluno setNome:_nomeTextField.text];
        [novoAluno setTia:_tiaTextField.text];
        
        [alunoSingleton salvar:novoAluno];
        alunos = [alunoSingleton todosAlunos];
    }
    
    
    [self cancelarEdicao];
    [_tableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nomeTextField resignFirstResponder];
    [_tiaTextField resignFirstResponder];
}


#pragma mark - TableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [alunos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alunoCell"];
    Aluno *aluno = [alunos objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:aluno.nome];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"TIA: %@",aluno.tia ]];

    UIImage *foto = [[FotoSingleton sharedInstance] recuperarFotoComNome:aluno.tia];
    
    if (foto) {
        [cell.imageView setImage:foto];
    }
    
    
    return cell;
}

-(void)setImageInput{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Desenvolvedor do MackMobile?" message:@"Simulador não têm camera, mas fique tranquilo, no iPhone irá funcionar!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]; [myAlertView show];
        }else{
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    foto = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    alunoSelecionado = [alunos objectAtIndex:indexPath.row];
    [_nomeTextField setText:alunoSelecionado.nome];
    [_tiaTextField setText:alunoSelecionado.tia];
    [_tiaTextField setEnabled:NO];
    [_botaoSalvar setTitle:@"Alterar" forState:UIControlStateNormal];
    [self.view addSubview:fotoToolBar];
}

@end
