--青色之焰✿藤原妹红
function c21164.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21164,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c21164.reccon)
	e1:SetTarget(c21164.rectg)
	e1:SetOperation(c21164.recop)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21164,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,21164)
	e4:SetCost(c21164.hspcost)
	e4:SetTarget(c21164.hsptg)
	e4:SetOperation(c21164.hspop)
	c:RegisterEffect(e4)
	--m limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c21164.synlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c21164.synlimit)
	c:RegisterEffect(e3)
end
function c21164.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t=Duel.GetAttackTarget()
	if ev==1 then t=Duel.GetAttacker() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabel(t:GetDefense())
	return t:GetLocation()==LOCATION_GRAVE and t:IsType(TYPE_MONSTER)
end
function c21164.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c21164.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c21164.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c21164.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21164.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c21164.synlimit(e,c)
	if not c then return false end
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_WIND)
end
