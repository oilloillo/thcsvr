 
--乐园的美妙巫女
function c10012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10012,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10012.cgcon)
	e1:SetCost(c10012.cgcost)
	e1:SetTarget(c10012.cgtg)
	e1:SetOperation(c10012.cgop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c10012.atkcon)
	e2:SetValue(c10012.atkval)
	c:RegisterEffect(e2)
end
function c10012.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10012.cgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c10012.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10012.cgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(100)
		tc:RegisterEffect(e1)
	end
end
function c10012.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.GetAttackTarget()~=nil
end
function c10012.atkval(e,c)
	return e:GetHandler():GetBattleTarget():GetLevel()*100
end