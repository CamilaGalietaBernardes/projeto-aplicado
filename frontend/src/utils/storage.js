export const salvar = (chave, valor) => {
  try {
    localStorage.setItem(chave, JSON.stringify(valor));
  } catch (e) {
    alert("Erro ao salvar dados.");
  }
};

export const ler = (chave, padrao = []) => {
  try {
    const dado = localStorage.getItem(chave);
    return dado ? JSON.parse(dado) : padrao;
  } catch (e) {
    return padrao;
  }
};