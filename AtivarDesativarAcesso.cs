        #region AtivarDesativarAcesso
        public void AtivarDesativarAcesso(string strRegistro, string strPerfilId, string strPerfilNome)
        {
            try
            {
                //Verifica se usu�rio tem acesso ao perfil, se existir, remove, se n�o existir, libera:
                using (var BllControleAcesso = new Bll.Ferias.ControleAcesso(Session["FuncRegistro"].ToString()))
                {
                    DataTable Dt = BllControleAcesso.GetAcessoPorRegistroPerfil(strRegistro, strPerfilId);
                    if (Dt?.Rows.Count > 0)
                    {
                        //Se possui acesso, ent�o dever� ser retirado com a a��o do click no checkbox:
                        if (BllControleAcesso.RemoveAcesso(Dt.Rows[0]["ID"].ToString(), strPerfilId.ToString()))
                        {
                            Master.NotificacaoSucessoGrande("Acesso ao perfil " + strPerfilNome.ToString() + " retirado com sucesso do usu�rio registro " + strRegistro.ToString() + ".");
                            return;
                        }
                        else
                        {
                            Master.NotificacaoErroGrande("Erro ao retirar o acesso ao perfil " + strPerfilNome.ToString() + " do usu�rio registro " + strRegistro.ToString() + ".");
                            return;
                        }
                    }
                    else
                    {
                        //Se N�O possui acesso, ent�o dever� ser inclu�do com a a��o do click no checkbox:

                        //Verifica se usu�rio possui cadastro para o registro do funcion�rio na tabela PIER.USUARIO (ATIVO):
                        DataTable DtUsuario = BllControleAcesso.GetUsuarioPorRegistro(strRegistro);
                        if (DtUsuario?.Rows.Count == 0)
                        {
                            Master.NotificacaoSucessoPequena("N�o foi encontrado registro (ativo) cadastrado para o Funcion�rio Registro:" + strRegistro.ToString() + " (PIER.USUARIO).");
                            return;
                        }
                        else
                        {
                            string strIdUsuarioPier = DtUsuario.Rows[0]["ID"].ToString();
                            string strIdSession = "";

                            //Verifica se usu�rio possui acesso ao sistema/perfil como inativo, se existir, apenas ativar o acesso, caso contr�rio ser� necess�rio criar:
                            DataTable DtAcessoInativoSistemaPerfil = BllControleAcesso.GetAcessoInativoSistemaPorRegistroPerfil(strRegistro, strPerfilId);
                            if (DtAcessoInativoSistemaPerfil?.Rows.Count > 0)
                            {
                                string strAcessoId = DtAcessoInativoSistemaPerfil.Rows[0]["ID"].ToString();

                                //Usu�rio j� possui acesso, por�m consta como INATIVO, ent�o, ser� necess�rio apenas ativar novamente o acesso:
                                if (BllControleAcesso.AtivaAcesso(strAcessoId, strPerfilId))
                                {
                                    Master.NotificacaoSucessoGrande("Acesso ao perfil " + strPerfilNome.ToString() + " ativado com sucesso para o usu�rio registro " + strRegistro.ToString() + ".");
                                    return;
                                }
                                else
                                {
                                    Master.NotificacaoErroGrande("Erro ao ativar o acesso ao perfil " + strPerfilNome.ToString() + " para o usu�rio registro " + strRegistro.ToString() + ".");
                                    return;
                                }
                            }
                            else
                            {
                                //Verifica se usu�rio possui acesso a outro perfil do mesmo sistema, se existir, utilizar o mesmo registro da tabela PIER.SESSAO:
                                DataTable DtAcessoLiberadoSistemaOutroPerfil = BllControleAcesso.GetAcessoLiberadoSistemaPorRegistroOutroPerfil(strRegistro, strPerfilId);
                                if (DtAcessoLiberadoSistemaOutroPerfil?.Rows.Count > 0)
                                {
                                    strIdSession = DtAcessoLiberadoSistemaOutroPerfil.Rows[0]["SESSAO_ID"].ToString();
                                }

                                //Se n�o encontrou registros para utilizar o mesmo SESSAO_ID, ser� necess�rio criar registro na tabela PIER.SESSAO para o usu�rio (strIdUsuarioPier):
                                if (string.IsNullOrEmpty(strIdSession))
                                {
                                    //Grava tabela PIER.SESSAO:
                                    strIdSession = BllControleAcesso.GravaSessao(strIdUsuarioPier).ToString();
                                }

                                //Grava tabela PIER.ACESSO:
                                if (BllControleAcesso.GravaAcesso(strPerfilId.ToString(), strIdUsuarioPier.ToString(), strIdSession.ToString()))
                                {
                                    Master.NotificacaoSucessoGrande("Acesso ao perfil " + strPerfilNome.ToString() + " gravado com sucesso para o usu�rio registro " + strRegistro.ToString() + ".");
                                    return;
                                }
                                else
                                {
                                    Master.NotificacaoErroGrande("Erro ao gravar o acesso ao perfil " + strPerfilNome.ToString() + " para o usu�rio registro " + strRegistro.ToString() + ".");
                                    return;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception Ex)
            {
                using (var Funcoes = new MasterSbsa.Util.Funcoes())
                {
                    Funcoes.LogErros(Ex, this, new StackTrace());
                }
                Master.NotificacaoErroGrande(Ex, this, new StackTrace());
            }
        }
        #endregion AtivarDesativarAcesso
