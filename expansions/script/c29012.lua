 
--古旧之琴的付丧神✿九十九弁々
function c29012.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29012,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29012.rectg)
	e2:SetOperation(c29012.recop)
	c:RegisterEffect(e2)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c29012.sccon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetCondition(c29012.condition)
	e6:SetTarget(c29012.sumlimit)
	c:RegisterEffect(e6)
end

c29012.DescSetName=0x826

function c29012.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=800 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-800)
	e:GetHandler():RegisterEffect(e1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c29012.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c29012.sccon(e)
	local seq=e:GetHandler():GetSequence()
	if seq~=6 and seq~=7 then return false end
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsCode(29014)
end
function c29012.condition(e)
	local seq=e:GetHandler():GetSequence()
	return seq==6 or seq==7
end
function c29012.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumtype==SUMMON_TYPE_PENDULUM and not c:IsSetCard(0x826)
end
