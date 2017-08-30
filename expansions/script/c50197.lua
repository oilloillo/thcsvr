 
--晓型驱逐舰-雷
function c50197.initial_effect(c)
	local temp = 0
	while temp<6 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50197,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c50197.rccost)
	e2:SetTarget(c50197.rctg)
	e2:SetOperation(c50197.rcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50197.filter(c)
	return c:IsSetCard(0x4bb) and not c:IsPublic()
end
function c50197.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50197.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c50197.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x514) then
		e:SetLabel(tc:GetAttack()*3)
	else
		e:SetLabel(tc:GetAttack())
	end
end
function c50197.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c50197.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,e:GetLabel(),REASON_EFFECT)
end
