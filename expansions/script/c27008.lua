 
--邪仙 霍青娥
function c27008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c27008.spcon)
	e1:SetOperation(c27008.spop)
	c:RegisterEffect(e1)
    --direct atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	--c:RegisterEffect(e2)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c27008.synlimit)
	c:RegisterEffect(e4)
	--damage reduce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c27008.rdcon)
	e5:SetOperation(c27008.rdop)
	c:RegisterEffect(e5)
	--Eraser
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(27008,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_DESTROYED)
	e6:SetTarget(c27008.tg)
	e6:SetOperation(c27008.op)
	c:RegisterEffect(e6)
end
function c27008.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c27008.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x208) and not c:IsCode(27007) and (c:IsRace(RACE_ZOMBIE) or c:IsRace(RACE_ROCK))
end
function c27008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c27008.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c27008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27008.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(1)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x47e0000)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2,true)
end
function c27008.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker()
end
function c27008.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c27008.filter(c)
	return c:IsSetCard(0x246) and c:IsAbleToHand()
end
function c27008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27008.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27008.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27008.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
