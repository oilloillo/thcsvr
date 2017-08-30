--逆转的命运之轮✿稀神探女
function c31027.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DECK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c31027.sdcon)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31027,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c31027.condition)
	e2:SetTarget(c31027.cointg)
	e2:SetOperation(c31027.coinop)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31027,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c31027.descost)
	e3:SetTarget(c31027.destg)
	e3:SetOperation(c31027.desop)
	c:RegisterEffect(e3)
end

c31027.DescSetName = 0x258

function c31027.sdcon(e)
	return e:GetHandler():GetAttack()==e:GetHandler():GetBaseAttack()
end
function c31027.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c31027.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c31027.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	e:SetLabel(0)
	local res=0
	if c:IsHasEffect(31067) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c:RegisterFlagEffect(31027,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,res,63-res)
	c31027.arcanareg(c,e,res)
end
function c31027.arcanareg(c,e,coin)
	local p=c:GetControler()
	if e:GetLabel()==1 then p=1-p end
	local val=c:GetFlagEffectLabel(31027)
	if val==1 then
		if Duel.Recover(1-p,500,REASON_EFFECT)>0 then
			Duel.Draw(1-p,1,REASON_EFFECT)
		end
	else
		local lp=Duel.GetLP(1-p)
		Duel.SetLP(1-p,lp-500)
		local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c31027.costfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x258
end
function c31027.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if g:FilterCount(c31027.costfilter,nil)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c31027.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffectLabel(31027)~=nil end
end
function c31027.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	c31027.arcanareg(c,e,res)
end
